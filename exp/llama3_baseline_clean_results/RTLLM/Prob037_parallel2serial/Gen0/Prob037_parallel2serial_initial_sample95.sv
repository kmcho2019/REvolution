module parallel2serial (
    input  logic        clk, 
    input  logic        rst_n, 
    input  logic [3:0]  d, 
    output logic        valid_out, 
    output logic        dout
);

logic [3:0] data;
logic [1:0] cnt;
logic valid;

always_ff @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        data <= 4'b0;
        cnt <= 2'b0;
        valid <= 1'b0;
    end else begin
        if (cnt == 2'b11) begin
            data <= d;
            cnt <= 2'b0;
            valid <= 1'b1;
        end else begin
            cnt <= cnt + 1'b1;
            valid <= 1'b0;
            data <= {data[2:0], data[3]};
        end
    end
end

always_comb begin
    dout = data[3];
    valid_out = valid;
end

endmodule