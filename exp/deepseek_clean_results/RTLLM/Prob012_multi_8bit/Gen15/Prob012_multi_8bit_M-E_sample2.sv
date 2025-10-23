module multi_8bit (
    input clk,          // Clock input
    input start,        // Start signal
    input [7:0] A,      // Multiplicand
    input [7:0] B,      // Multiplier
    output reg [15:0] product,  // Product output
    output reg done     // Done signal
);

    reg [2:0] bit_counter;  // Tracks which bit we're processing
    reg [7:0] B_reg;       // Shift register for multiplier
    reg [15:0] accum;      // Accumulator
    reg [15:0] A_ext;      // Extended multiplicand

    // State machine
    typedef enum {IDLE, RUNNING} state_t;
    state_t state;

    always @(posedge clk) begin
        case (state)
            IDLE: begin
                if (start) begin
                    // Initialize registers
                    B_reg <= B;
                    accum <= 16'b0;
                    A_ext <= {8'b0, A};
                    bit_counter <= 3'b0;
                    done <= 1'b0;
                    state <= RUNNING;
                end
            end
            
            RUNNING: begin
                // Add shifted A if current bit is set
                if (B_reg[0]) begin
                    accum <= accum + A_ext;
                end
                
                // Shift operations for next cycle
                A_ext <= A_ext << 1;
                B_reg <= B_reg >> 1;
                bit_counter <= bit_counter + 1;
                
                // Check for completion
                if (bit_counter == 3'd7) begin
                    product <= accum;
                    done <= 1'b1;
                    state <= IDLE;
                end
            end
        endcase
    end

endmodule