module width_8to16(
    input clk,
    input rst_n,
    input valid_in,
    input [7:0] data_in,
    output reg valid_out,
    output reg [15:0] data_out
);

reg [7:0] data_lock;
reg data_lock_valid;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        data_lock_valid <= 1'b0;
        data_lock <= 8'b0;
        data_out <= 16'b0;
        valid_out <= 1'b0;
    end else begin
        if (valid_in) begin
            if (!data_lock_valid) begin
                // Store the first valid data and set the flag
                data_lock <= data_in;
                data_lock_valid <= 1'b1;
            end else begin
                // Concatenate the stored data and the new data, and update output
                data_out <= {data_lock, data_in};
                valid_out <= 1'b1;
                // Reset the flag and stored data for next operation
                data_lock_valid <= 1'b0;
            end
        end else begin
            // If input is not valid, do not update output
            valid_out <= 1'b0;
        end
    end
end

endmodule