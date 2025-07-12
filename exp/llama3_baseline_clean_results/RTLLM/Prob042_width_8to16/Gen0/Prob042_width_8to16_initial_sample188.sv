module width_8to16(
    input clk,
    input rst_n,
    input valid_in,
    input [7:0] data_in,
    output logic valid_out,
    output logic [15:0] data_out
);

logic [7:0] data_lock;
logic flag;

always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        data_out <= 16'd0;
        flag <= 1'b0;
        data_lock <= 8'd0;
    end else if (valid_in) begin
        if (!flag) begin
            data_lock <= data_in;
            flag <= 1'b1;
        end else begin
            data_out <= {data_lock, data_in};
            flag <= 1'b0;
            valid_out <= 1'b1;
        end
    end else begin
        valid_out <= 1'b0;
    end
end

endmodule