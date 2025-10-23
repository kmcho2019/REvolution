module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

    // State definitions
    localparam IDLE = 2'b00;
    localparam CALC = 2'b01;
    localparam DONE = 2'b10;

    reg [1:0] state;
    reg [15:0] multiplicand;
    reg [8:0] multiplier;  // 8-bit multiplier + 1-bit previous
    reg [2:0] ctr;         // Counts 0-3 (4 steps for 8 bits)
    reg [15:0] accumulator;
    reg [15:0] next_accum;

    // Booth encoding combinational logic
    wire [1:0] booth_sel = multiplier[1:0];
    wire [15:0] booth_pp_pos = multiplicand;
    wire [15:0] booth_pp_neg = -multiplicand;
    wire [15:0] booth_pp_pos2 = multiplicand << 1;
    wire [15:0] booth_pp_neg2 = -(multiplicand << 1);

    always @(*) begin
        case (booth_sel)
            2'b01: next_accum = accumulator + booth_pp_pos;
            2'b10: next_accum = accumulator + booth_pp_neg;
            2'b11: next_accum = accumulator + booth_pp_pos2;
            2'b00: next_accum = accumulator + booth_pp_neg2;
            default: next_accum = accumulator;
        endcase
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Initialize registers with sign extension
            multiplicand <= {{8{a[7]}}, a};
            multiplier <= {b, 1'b0};  // multiplier + previous bit (init to 0)
            accumulator <= 16'b0;
            ctr <= 3'b0;
            rdy <= 1'b0;
            state <= IDLE;
            p <= 16'b0;
        end else begin
            case (state)
                IDLE: begin
                    state <= CALC;
                    rdy <= 1'b0;
                end
                
                CALC: begin
                    if (ctr < 3) begin
                        // Update accumulator with partial product
                        accumulator <= next_accum;
                        
                        // Arithmetic shift right multiplier by 2 (keep sign)
                        multiplier <= {{2{multiplier[8]}}, multiplier[8:2]};
                        
                        // Shift multiplicand left by 2 for next partial product
                        multiplicand <= multiplicand << 2;
                        
                        ctr <= ctr + 1;
                    end else begin
                        // Final accumulation step
                        accumulator <= next_accum;
                        state <= DONE;
                    end
                end
                
                DONE: begin
                    p <= accumulator;
                    rdy <= 1'b1;
                    state <= IDLE;  // Wait for next reset
                end
            endcase
        end
    end

endmodule