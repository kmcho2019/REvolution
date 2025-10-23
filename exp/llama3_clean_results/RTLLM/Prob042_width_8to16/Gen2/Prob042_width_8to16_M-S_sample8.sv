module width_8to16 (
    input           clk,
    input           rst_n,
    input           valid_in,
    input   [7:0]   data_in,
    output  reg     valid_out,
    output  reg [15:0]  data_out
);

reg [7:0] data_lock;
reg lock_valid;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        data_lock <= 8'd0;
        lock_valid <= 1'b0;
        valid_out <= 1'b0;
        data_out <= 16'd0;
    end
    else begin
        if (valid_in) begin
            if (lock_valid) begin
                // Second valid data arrived, concatenate and output
                data_out <= {data_lock, data_in};
                valid_out <= 1'b1;
                lock_valid <= 1'b0;
            end
            else begin
                // First valid data, store it
                data_lock <= data_in;
                lock_valid <= 1'b1;
                valid_out <= 1'b0;
            end
        end
        else begin
            // No valid data, maintain previous state
            valid_out <= 1'b0;
        end
    end
end

endmodule