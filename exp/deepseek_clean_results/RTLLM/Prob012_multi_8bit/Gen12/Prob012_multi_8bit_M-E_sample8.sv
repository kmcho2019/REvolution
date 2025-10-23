module multi_8bit (
    input clk,          // Clock input
    input start,        // Start signal
    input [7:0] A,      // Multiplicand
    input [7:0] B,      // Multiplier
    output reg [15:0] product,  // Product output
    output reg done     // Done flag
);

    reg [2:0] bit_counter;  // Counts 0-7 bits
    reg [15:0] accumulator;
    reg [7:0] multiplicand;
    reg [7:0] multiplier;

    // State machine
    typedef enum {IDLE, CALCULATING} state_t;
    state_t state;

    always @(posedge clk) begin
        case (state)
            IDLE: begin
                if (start) begin
                    multiplicand <= A;
                    multiplier <= B;
                    accumulator <= 16'b0;
                    bit_counter <= 3'b0;
                    done <= 1'b0;
                    state <= CALCULATING;
                end
            end
            
            CALCULATING: begin
                // Add shifted multiplicand if current bit is set
                if (multiplier[0]) begin
                    accumulator <= accumulator + {8'b0, multiplicand};
                end
                
                // Right shift multiplier and left shift multiplicand
                multiplier <= {1'b0, multiplier[7:1]};
                multiplicand <= {multiplicand[6:0], 1'b0};
                
                // Increment bit counter
                bit_counter <= bit_counter + 1;
                
                // Check if done
                if (bit_counter == 3'd7) begin
                    product <= accumulator;
                    done <= 1'b1;
                    state <= IDLE;
                end
            end
        endcase
    end

    // Initial state
    initial begin
        state = IDLE;
        done = 1'b0;
    end

endmodule