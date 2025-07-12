module multi_8bit (
    input clk,          // Clock input
    input start,        // Start signal
    input [7:0] A,      // Multiplicand
    input [7:0] B,      // Multiplier
    output reg [15:0] product,  // Product output
    output reg done     // Done flag
);

    reg [2:0] count;    // Cycle counter (0-7)
    reg [7:0] B_reg;    // Shift register for multiplier
    reg [15:0] accum;   // Accumulator
    reg [15:0] A_ext;   // Extended multiplicand

    always @(posedge clk) begin
        if (start) begin
            // Initialize on start
            count <= 3'b0;
            B_reg <= B;
            accum <= 16'b0;
            A_ext <= {8'b0, A};
            done <= 1'b0;
        end else if (!done && count < 3'd7) begin
            // Process one bit per cycle
            if (B_reg[0]) begin
                accum <= accum + A_ext;
            end
            
            // Shift operations
            A_ext <= A_ext << 1;
            B_reg <= B_reg >> 1;
            count <= count + 1;
            
            // Set done flag after last cycle
            if (count == 3'd6) done <= 1'b1;
        end
    end

    // Output the accumulated result
    always @(*) begin
        product = done ? accum : 16'b0;
    end

endmodule