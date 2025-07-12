module width_8to16 (
    input         clk,
    input         rst_n,
    input         valid_in,
    input  [7:0]  data_in,
    output        valid_out,
    output [15:0] data_out
);

reg [7:0]  data_lock;
reg         data_valid;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        data_lock <= 8'd0;
        data_valid <= 1'b0;
    end else begin
        if (valid_in) begin
            if (!data_valid) begin
                data_lock <= data_in;
                data_valid <= 1'b1;
            end else begin
                data_out <= {data_lock, data_in};
                valid_out <= 1'b1;
                data_valid <= 1'b0;
            end
        end else begin
            valid_out <= 1'b0;
        end
    end
end

endmodule