module multi_booth_8bit(
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output [15:0] p,
    output reg rdy
);

reg [15:0] multiplicand;
reg [15:0] multiplier;
reg [15:0] product;
reg [4:0] ctr;

// Enum for states
enum logic [1:0] {IDLE, RUNNING, DONE} state, next_state;

always @(posedge clk or posedge reset) begin
    if(reset) begin
        multiplicand <= {{8{b[7]}}, b};
        multiplier <= {{8{a[7]}}, a};
        product <= 0;
        ctr <= 0;
        state <= IDLE;
        rdy <= 0;
    end else begin
        state <= next_state;
        case(state)
            IDLE: begin
                if(a!= 0 || b!= 0) begin
                    multiplicand <= {{8{b[7]}}, b};
                    multiplier <= {{8{a[7]}}, a};
                    product <= 0;
                    ctr <= 0;
                    next_state <= RUNNING;
                end else begin
                    next_state <= IDLE;
                end
            end
            RUNNING: begin
                if(ctr < 8) begin
                    // Implement Booth algorithm for Radix-4
                    case({multiplier[ctr+1], multiplier[ctr]})
                        2'b00: begin // Do nothing
                            product <= product;
                        end
                        2'b01: begin // Add multiplicand
                            product <= product + multiplicand;
                        end
                        2'b10: begin // Subtract multiplicand
                            product <= product - multiplicand;
                        end
                        2'b11: begin // Subtract multiplicand and shift
                            product <= product - multiplicand;
                        end
                    endcase

                    // Update multiplicand register (shift by 2 for Radix-4)
                    multiplicand <= multiplicand << 2;

                    // Increment counter
                    ctr <= ctr + 1;
                    next_state <= RUNNING;
                end else begin
                    next_state <= DONE;
                end
            end
            DONE: begin
                rdy <= 1;
                next_state <= DONE;
            end
        endcase
    end
end

assign p = product;

endmodule