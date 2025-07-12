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
    
    // Internal registers
    reg [15:0] multiplicand;
    reg [15:0] multiplier;
    reg [1:0] state;
    reg [1:0] counter;
    reg prev_lsb;
    
    // Pre-computed partial products
    wire [15:0] pp_0 = 16'b0;
    wire [15:0] pp_A = multiplicand;
    wire [15:0] pp_2A = multiplicand << 1;
    wire [15:0] pp_negA = -multiplicand;
    wire [15:0] pp_neg2A = -(multiplicand << 1);
    
    // Booth encoding (combinational)
    wire [2:0] booth_bits = {multiplier[1:0], prev_lsb};
    
    // Partial product selection (combinational)
    wire [15:0] partial_product = 
        (booth_bits == 3'b000 || booth_bits == 3'b111) ? pp_0 :
        (booth_bits == 3'b001 || booth_bits == 3'b010) ? pp_A :
        (booth_bits == 3'b011) ? pp_2A :
        (booth_bits == 3'b100) ? pp_neg2A :
        (booth_bits == 3'b101 || booth_bits == 3'b110) ? pp_negA : pp_0;
    
    // Shifted partial product (combinational)
    wire [15:0] shifted_pp = partial_product << (counter * 2);
    
    // State machine and control
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            multiplicand <= {{8{a[7]}}, a};
            multiplier <= {{8{b[7]}}, b};
            p <= 16'b0;
            rdy <= 1'b0;
            counter <= 2'b0;
            prev_lsb <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    state <= CALC;
                    counter <= 2'b0;
                end
                
                CALC: begin
                    if (counter == 2'b11) begin
                        state <= DONE;
                        rdy <= 1'b1;
                    end
                    counter <= counter + 1;
                    multiplier <= multiplier >> 2;
                    prev_lsb <= multiplier[1];
                end
                
                DONE: begin
                    // Maintain done state until reset
                end
            endcase
        end
    end
    
    // Product accumulation (separate always block)
    always @(posedge clk) begin
        if (reset) begin
            p <= 16'b0;
        end else if (state == CALC) begin
            p <= p + shifted_pp;
        end
    end

endmodule