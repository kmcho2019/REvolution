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
    reg [3:0] ctr;
    reg [15:0] accumulator;

    // Booth encoding outputs
    wire [15:0] booth_pp;
    wire [1:0] booth_sel = multiplier[1:0];

    // Booth encoding combinational logic
    assign booth_pp = 
        (booth_sel == 2'b01) ? multiplicand :
        (booth_sel == 2'b10) ? -multiplicand :
        (booth_sel == 2'b11) ? (multiplicand << 1) :
        (booth_sel == 2'b00) ? -(multiplicand << 1) : 16'b0;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Initialize registers with sign extension
            multiplicand <= {{8{a[7]}}, a};
            multiplier <= {b, 1'b0};  // multiplier + previous bit (init to 0)
            accumulator <= 16'b0;
            ctr <= 4'b0;
            rdy <= 1'b0;
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    state <= CALC;
                end
                
                CALC: begin
                    if (ctr < 4) begin
                        // Accumulate partial product
                        accumulator <= accumulator + booth_pp;
                        
                        // Arithmetic shift right multiplier (keep sign)
                        multiplicand <= multiplicand << 2;
                        multiplier <= {multiplier[8], multiplier[8], multiplier[8:2]};
                        
                        ctr <= ctr + 1;
                    end else begin
                        state <= DONE;
                    end
                end
                
                DONE: begin
                    p <= accumulator;
                    rdy <= 1'b1;
                    state <= IDLE;
                end
            endcase
        end
    end

endmodule