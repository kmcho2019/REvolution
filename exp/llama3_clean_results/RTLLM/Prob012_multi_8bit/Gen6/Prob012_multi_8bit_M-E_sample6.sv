module multi_8bit(
    input   clk,        // Clock signal
    input   reset_n,    // Active low reset
    input   [7:0] A,   // First 8-bit input operand (multiplicand)
    input   [7:0] B,   // Second 8-bit input operand (multiplier)
    output  [15:0] product,  // 16-bit output representing the product of A and B
    output  done        // Signal indicating the multiplication is complete
);

    reg [2:0] state;  // State register for the FSM
    reg [15:0] acc;   // Accumulator for the product
    reg [7:0] shift_reg;  // Shift register for the multiplicand (A)
    reg [7:0] b_reg;     // Register to hold the multiplier (B)

    always @(posedge clk or negedge reset_n) begin
        if (~reset_n) begin
            state <= 3'b000;  // Reset the state machine
            acc <= 16'd0;     // Reset the accumulator
            shift_reg <= 8'd0; // Reset the shift register
            b_reg <= 8'd0;    // Reset the multiplier register
            done <= 1'b0;     // Reset the done signal
        end else begin
            case (state)
                3'b000: begin  // Initial state
                    shift_reg <= A;  // Load the multiplicand into the shift register
                    b_reg <= B;      // Load the multiplier into the register
                    state <= 3'b001; // Move to the next state
                end
                3'b001: begin  // Check each bit of the multiplier
                    if (b_reg[0]) begin  // If the current bit is set
                        acc <= acc + {8'd0, shift_reg};  // Add the shifted multiplicand to the accumulator
                    end
                    shift_reg <= {shift_reg[6:0], 1'b0};  // Shift the multiplicand left
                    b_reg <= {b_reg[6:0], 1'b0};         // Shift the multiplier left
                    if (b_reg == 8'd0) begin  // If all bits of the multiplier have been processed
                        state <= 3'b010;     // Move to the final state
                    end else begin
                        state <= 3'b001;     // Stay in the current state
                    end
                end
                3'b010: begin  // Final state
                    product <= acc;          // Output the final product
                    done <= 1'b1;           // Set the done signal
                end
            endcase
        end
    end

endmodule