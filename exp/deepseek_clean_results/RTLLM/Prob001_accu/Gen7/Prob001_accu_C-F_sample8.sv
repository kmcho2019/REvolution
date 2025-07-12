module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output reg [9:0] data_out
);

reg [1:0] count;          // 2-bit counter (0-3)
reg [9:0] accumulator;    // 10-bit accumulator
wire count_full = (count == 2'b11);  // Separate comparison for better timing

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Synchronous reset
        count <= 2'b00;
        accumulator <= 10'b0;
        data_out <= 10'b0;
        valid_out <= 1'b0;
    end
    else begin
        // Default outputs
        valid_out <= 1'b0;

        // Accumulation logic
        if (valid_in && !count_full) begin
            accumulator <= accumulator + data_in;
            count <= count + 1'b1;
        end

        // Output generation
        if (valid_in && count_full) begin
            data_out <= accumulator + data_in;
            valid_out <= 1'b1;
            // Reset for next accumulation
            count <= 2'b00;
            accumulator <= 10'b0;
        end
    end
end

endmodule