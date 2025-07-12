module TopModule (
    input clk,          // Clock input needed for sequential logic
    input reset,        // Reset input
    input [7:0] in,     // 8-bit input
    output reg parity   // Registered output
);
    reg [2:0] bit_counter;  // 3-bit counter (0-7)
    reg running_parity;     // Stores intermediate parity
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            bit_counter <= 3'b0;
            running_parity <= 1'b0;
            parity <= 1'b0;
        end
        else begin
            if (bit_counter == 3'd0) begin
                // Initialize at start of new calculation
                running_parity <= in[0];
                bit_counter <= 3'd1;
            end
            else if (bit_counter < 3'd7) begin
                // Process each bit sequentially
                running_parity <= running_parity ^ in[bit_counter];
                bit_counter <= bit_counter + 1;
            end
            else begin
                // Final bit and output
                parity <= running_parity ^ in[7];
                bit_counter <= 3'd0;  // Ready for next calculation
            end
        end
    end
endmodule