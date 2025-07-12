module TopModule(
    input  clk,
    input  areset,
    input  load,
    input  ena,
    input  [3:0] data,
    output reg [3:0] q
);

wire [3:0] next_q;

assign next_q = load ? data : (ena ? {1'b0, q[3:1]} : q);

always @(posedge clk or posedge areset) begin
    if(areset) begin
        q <= 4'b0000;
    end else begin
        q <= next_q;
    end
end

endmodule