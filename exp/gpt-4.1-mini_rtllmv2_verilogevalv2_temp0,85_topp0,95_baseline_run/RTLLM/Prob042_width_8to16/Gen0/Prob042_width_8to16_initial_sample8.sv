module width_8to16 (
    input           clk,
    input           rst_n,
    input           valid_in,
    input  [7:0]    data_in,
    output reg      valid_out,
    output reg [15:0] data_out
);

reg [7:0] data_lock;
reg flag;  // 0: no data stored, 1: one data stored waiting for second byte

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        data_lock <= 8'd0;
        data_out <= 16'd0;
        valid_out <= 1'b0;
        flag <= 1'b0;
    end else begin
        valid_out <= 1'b0; // default no valid output this cycle

        if (valid_in) begin
            if (flag == 1'b0) begin
                // Store first 8-bit data
                data_lock <= data_in;
                flag <= 1'b1;
            end else begin
                // Second 8-bit data arrived, produce output next cycle
                data_out <= {data_lock, data_in};
                valid_out <= 1'b1;
                flag <= 1'b0;
            end
        end
    end
end

endmodule