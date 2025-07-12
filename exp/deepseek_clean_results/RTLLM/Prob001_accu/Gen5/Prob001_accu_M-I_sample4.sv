module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output reg [9:0] data_out
);

reg count;  // 1-bit counter (counts 0-1, effectively tracking modulo 4)
reg [9:0] accumulator;  // Stores running sum
reg [7:0] input_buffer [0:1];  // Buffer for carry-save addition

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset all registers
        count <= 1'b0;
        accumulator <= 10'b0;
        valid_out <= 1'b0;
        data_out <= 10'b0;
        input_buffer[0] <= 8'b0;
        input_buffer[1] <= 8'b0;
    end
    else begin
        // Default outputs
        valid_out <= 1'b0;
        
        if (valid_in) begin
            // Carry-save addition: buffer two inputs before adding to accumulator
            if (!count) begin
                input_buffer[0] <= data_in;
            end
            else begin
                input_buffer[1] <= data_in;
                // Only add to accumulator every 2 inputs (reduces adder usage)
                accumulator <= accumulator + input_buffer[0] + input_buffer[1];
            end
            
            // Detect 4th input (count toggles twice)
            if (&{count, input_buffer[0][0], input_buffer[1][0]}) begin
                data_out <= accumulator + data_in;
                valid_out <= 1'b1;
                accumulator <= 10'b0;
            end
            
            count <= ~count;  // Toggle counter
        end
    end
end

endmodule