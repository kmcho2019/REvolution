module multi_8bit (
    input clk,          // Clock input
    input start,        // Start signal
    input [7:0] A,      // Multiplicand
    input [7:0] B,      // Multiplier
    output reg [15:0] product,  // Product output
    output reg done     // Done signal
);

    reg [2:0] bit_counter;  // Counts from 0 to 7
    reg [15:0] accumulator; // Accumulator register
    reg [7:0] shifted_A;    // Shifted version of A
    reg running;            // Operation in progress

    always @(posedge clk) begin
        if (start) begin
            // Initialize on start
            accumulator <= 16'b0;
            shifted_A <= A;
            bit_counter <= 3'b0;
            running <= 1'b1;
            done <= 1'b0;
        end else if (running) begin
            // Process current bit
            if (B[bit_counter]) begin
                accumulator <= accumulator + shifted_A;
            end
            
            // Shift A left for next bit position
            shifted_A <= shifted_A << 1;
            
            // Increment bit counter
            bit_counter <= bit_counter + 1;
            
            // Check if done
            if (bit_counter == 3'd7) begin
                running <= 1'b0;
                done <= 1'b1;
                product <= accumulator + (B[bit_counter] ? shifted_A : 16'b0);
            end
        end
    end

    // Combinational version for simulation comparison
    initial begin
        product = 16'b0;
        done = 1'b0;
    end

endmodule