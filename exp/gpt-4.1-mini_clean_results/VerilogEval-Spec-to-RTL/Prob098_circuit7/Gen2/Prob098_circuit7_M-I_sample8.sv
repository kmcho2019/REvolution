module TopModule (
    input clk,
    input a,
    output reg q
);
    wire next_q = ~a;
    always @(posedge clk) begin
        if (q != next_q)
            q <= next_q;
    end
endmodule