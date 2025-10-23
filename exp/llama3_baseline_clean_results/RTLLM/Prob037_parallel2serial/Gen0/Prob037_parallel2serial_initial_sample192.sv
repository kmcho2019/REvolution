module parallel2serial (
    input           clk,
    input           rst_n,
    input   [3:0]   d,
    output  logic   valid_out,
    output  logic   dout
);

logic [1:0] cnt;
logic [3:0] data;

always_ff @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt     <= 2'b00;
        data    <= 4'b0000;
        valid_out <= 1'b0;
    end else begin
        if (cnt == 2'b11) begin
            cnt     <= 2'b00;
            data    <= d;
            valid_out <= 1'b1;
        end else begin
            cnt     <= cnt + 1'b1;
            valid_out <= 1'b0;
            data    <= {data[2:0], 1'b0};
        end
    end
end

assign dout = data[3];

endmodule