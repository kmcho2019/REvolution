module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

wire [2:0] next_count = q + 1'b1;
wire wrap_around = (q == 3'd6);

always @(posedge clk) begin
    if (a) begin
        q <= 3'd4;
    end else begin
        q <= wrap_around ? 3'd0 : next_count;
    end
end

endmodule