module TopModule (
    input clk,
    input [7:0] d,
    output reg [7:0] q
);

    reg [7:0] next_q;

    always @(*) begin
        next_q = d;  // Simple pass-through in this case
    end

    always @(posedge clk) begin
        q <= next_q;
    end

endmodule