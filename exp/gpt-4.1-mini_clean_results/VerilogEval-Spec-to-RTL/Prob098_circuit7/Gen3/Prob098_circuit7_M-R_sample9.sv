module TopModule (
    input clk,
    input a,
    output reg q
);
    wire d;
    assign d = ~a;  // combinational logic: D input is inverted 'a'

    always @(posedge clk) begin
        q <= d;    // sequential logic: q captures d at clock edge
    end
endmodule