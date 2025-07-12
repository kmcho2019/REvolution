module width_8to16 (
    input           clk,
    input           rst_n,
    input           valid_in,
    input   [7:0]   data_in,
    output reg      valid_out,
    output reg [15:0] data_out
);

reg [7:0] data_lock;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        data_out  <= 16'd0;
        valid_out <= 1'b0;
        data_lock <= 8'd0;
    end
    else begin
        if (valid_in) begin
            if (data_lock == 8'd0) begin
                // Store the first data
                data_lock <= data_in;
                valid_out <= 1'b0; // Not yet valid
            end
            else begin
                // Concatenate the stored data with the new data and output
                data_out  <= {data_lock, data_in};
                valid_out <= 1'b1;
                data_lock <= 8'd0; // Reset data_lock for the next set of data
            end
        end
        else begin
            valid_out <= 1'b0; // If no valid input, output is not valid
        end
    end
end

endmodule