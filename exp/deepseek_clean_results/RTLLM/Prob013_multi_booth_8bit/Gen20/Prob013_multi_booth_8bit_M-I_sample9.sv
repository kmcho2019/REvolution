module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

    // State definitions
    localparam IDLE = 1'b0;
    localparam CALC = 1'b1;

    // Internal registers
    reg [15:0] multiplicand;
    reg [7:0] multiplier;
    reg prev_lsb;
    reg state;
    reg [1:0] counter;  // Reduced to 2 bits
    
    // Booth encoding
    wire [2:0] booth_bits = {multiplier[1:0], prev_lsb};
    
    // Arithmetic operations (combinational)
    wire [15:0] arith_result;
    assign arith_result = 
        (booth_bits == 3'b001 || booth_bits == 3'b010) ? p + multiplicand :
        (booth_bits == 3'b011) ? p + (multiplicand << 1) :
        (booth_bits == 3'b100) ? p - (multiplicand << 1) :
        (booth_bits == 3'b101 || booth_bits == 3'b110) ? p - multiplicand :
        p;  // Default case (000,111)

    always @(posedge clk) begin
        if (reset) begin
            // Initialize registers
            p <= 16'b0;
            multiplicand <= {{8{a[7]}}, a};
            multiplier <= b;
            prev_lsb <= 1'b0;
            counter <= 2'b0;
            rdy <= 1'b0;
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    state <= CALC;
                    rdy <= 1'b0;
                end
                
                CALC: begin
                    if (counter < 3) begin  // 4 iterations (0-3)
                        // Update product register
                        p <= arith_result;
                        
                        // Shift operations
                        multiplicand <= multiplicand << 2;
                        prev_lsb <= multiplier[1];
                        multiplier <= multiplier >> 2;
                        
                        counter <= counter + 1;
                    end else begin
                        // Final operation
                        p <= arith_result;
                        rdy <= 1'b1;
                        state <= IDLE;
                    end
                end
            endcase
        end
    end

endmodule