module TopModule (
    input clk,
    input a,
    output reg q
);
    wire d;
    // Combinational next state logic: d = ~(q & a)
    assign d = ~(q & a);

    always @(posedge clk) begin
        q <= d;
    end
endmodule