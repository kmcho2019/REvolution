module multi_8bit(
    input   [7:0] A,  // First 8-bit input operand (multiplicand)
    input   [7:0] B,  // Second 8-bit input operand (multiplier)
    output  [15:0] product  // 16-bit output representing the product of A and B
);

    reg [15:0] accumulator;  // 16-bit accumulator to store the intermediate results
    reg [7:0] shifted_A;  // Shifted multiplicand
    reg [2:0] state;  // State machine to control the multiplication process
    reg [7:0] counter;  // Counter to iterate through each bit of the multiplier

    always @(posedge clk) begin
        case (state)
            3'b000: begin  // Initialization state
                accumulator <= 16'd0;  // Initialize the accumulator to zero
                shifted_A <= A;  // Initialize the shifted multiplicand
                counter <= 8'd0;  // Initialize the counter
                state <= 3'b001;  // Transition to the next state
            end
            3'b001: begin  // Multiplication state
                if (counter == 8'd8) begin  // Check if all bits have been processed
                    state <= 3'b010;  // Transition to the final state
                end else if (B[counter] == 1'b1) begin  // Check if the current bit is set
                    accumulator <= accumulator + shifted_A;  // Add the shifted multiplicand to the accumulator
                end
                shifted_A <= shifted_A << 1;  // Shift the multiplicand left by one bit position
                counter <= counter + 1'd1;  // Increment the counter
            end
            3'b010: begin  // Final state
                product <= accumulator;  // Assign the final product to the output port
            end
        endcase
    end

endmodule