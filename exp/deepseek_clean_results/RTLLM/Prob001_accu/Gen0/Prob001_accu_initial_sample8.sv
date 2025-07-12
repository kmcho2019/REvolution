module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output reg [9:0] data_out
);

reg [1:0] count;  // Counts 0-3 (4 inputs)
reg [9:0] accumulator;  // Stores running sum (8+8+8+8 = max 1020, fits in 10 bits)

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset all registers
        count <= 2'b00;
        accumulator <= 10'b0;
        valid_out <= 1'b0;
        data_out <= 10'b0;
    end
    else begin
        // Default outputs
        valid_out <= 1'b0;
        
        if (valid_in) begin
            if (count == 2'b11) begin
                // On 4th input: output sum and reset
                data_out <= accumulator + data_in;
                valid_out <= 1'b1;
                count <= 2'b00;
                accumulator <= 10'b0;
            end
            else begin
                // Accumulate input and increment count
                accumulator <= accumulator + data_in;
                count <= count + 1'b1;
            end
        end
    end
end

endmodule