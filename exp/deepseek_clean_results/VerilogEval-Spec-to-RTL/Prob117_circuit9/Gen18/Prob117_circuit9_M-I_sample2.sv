module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

wire update_en = ~a | (q != 3'd4);
wire [2:0] next_q = (q == 3'd6) ? 3'd0 : q + 1'b1;

always @(posedge clk) begin
    if (update_en) begin
        if (a)
            q <= 3'd4;
        else
            q <= next_q;
    end
end

endmodule