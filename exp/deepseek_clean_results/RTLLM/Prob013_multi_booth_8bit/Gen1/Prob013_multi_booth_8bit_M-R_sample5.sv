module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output rdy
);

// State machine definition
typedef enum {IDLE, COMPUTE, DONE} state_t;
reg [1:0] state;

// Internal registers
reg [15:0] multiplicand;  // Sign-extended multiplicand
reg [16:0] product;       // Product register (extra bit for sign)
reg [7:0] multiplier;     // Multiplier (shrinks as we process bits)
reg [2:0] ctr;            // 3-bit counter (0-4)
reg prev_lsb;             // Previous LSB for Booth encoding

// Combinational outputs
assign rdy = (state == DONE);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        // Initialize on reset
        state <= IDLE;
        multiplicand <= {{8{a[7]}}, a};
        product <= 17'b0;
        multiplier <= b;
        ctr <= 3'b0;
        prev_lsb <= 1'b0;
        p <= 16'b0;
    end else begin
        case (state)
            IDLE: begin
                // Start computation
                state <= COMPUTE;
                product <= 17'b0;
                ctr <= 3'b0;
                prev_lsb <= 1'b0;
            end
            
            COMPUTE: begin
                if (ctr < 4) begin
                    // Booth Radix-4 encoding
                    case ({multiplier[1:0], prev_lsb})
                        3'b000, 3'b111: begin
                            // Do nothing
                            product <= product;
                        end
                        3'b001, 3'b010: begin
                            // Add multiplicand
                            product <= product + $signed({1'b0, multiplicand});
                        end
                        3'b011: begin
                            // Add 2*multiplicand
                            product <= product + $signed({1'b0, multiplicand << 1});
                        end
                        3'b100: begin
                            // Subtract 2*multiplicand
                            product <= product - $signed({1'b0, multiplicand << 1});
                        end
                        3'b101, 3'b110: begin
                            // Subtract multiplicand
                            product <= product - $signed({1'b0, multiplicand});
                        end
                    endcase
                    
                    // Arithmetic right shift of product and multiplier
                    product <= $signed(product) >>> 2;
                    multiplier <= multiplier >> 2;
                    prev_lsb <= multiplier[0];
                    
                    ctr <= ctr + 1;
                end else begin
                    // Computation complete
                    state <= DONE;
                    p <= product[15:0];
                end
            end
            
            DONE: begin
                // Hold until next reset
                state <= DONE;
            end
        endcase
    end
end

endmodule