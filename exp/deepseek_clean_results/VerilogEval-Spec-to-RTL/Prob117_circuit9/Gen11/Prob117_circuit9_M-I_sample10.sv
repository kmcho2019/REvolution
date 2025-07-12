module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

reg wrap_around;
wire [2:0] next_val = (q == 3'd6) ? 3'd0 : (q + 1'b1);

always @(posedge clk) begin
    wrap_around <= (q == 3'd6);
    if (a) begin
        q <= 3'd4;
    end else begin
        q <= next_val;
    end
end

endmodule