// Simplified D Flip-Flop module with active high asynchronous reset
module TopModule(
    input           clk,
    input           areset,
    input   [7:0]   d,
    output  [7:0]   q
);

    reg [7:0] q;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            q <= 8'b0;
        end else if (posedge clk) begin
            q <= d;
        end
    end

endmodule