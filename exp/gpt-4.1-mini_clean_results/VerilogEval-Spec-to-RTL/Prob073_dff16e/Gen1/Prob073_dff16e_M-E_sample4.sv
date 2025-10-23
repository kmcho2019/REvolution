module TopModule (
    input         clk,
    input         resetn,
    input  [1:0]  byteena,
    input  [15:0] d,
    output reg [15:0] q
);

wire [7:0] upper_mask = {8{byteena[1]}};
wire [7:0] lower_mask = {8{byteena[0]}};

always @(posedge clk) begin
    if (!resetn) begin
        q <= 16'd0;
    end else begin
        q[15:8] <= (q[15:8] & ~upper_mask) | (d[15:8] & upper_mask);
        q[7:0]  <= (q[7:0]  & ~lower_mask) | (d[7:0]  & lower_mask);
    end
end

endmodule