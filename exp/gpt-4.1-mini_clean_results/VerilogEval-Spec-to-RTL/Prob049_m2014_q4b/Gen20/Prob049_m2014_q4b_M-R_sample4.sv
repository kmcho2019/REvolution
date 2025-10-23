module TopModule (
    input  clk,
    input  ar,   // asynchronous active-high reset
    input  d,
    output reg q
);

    wire next_q = ar ? 1'b0 : d;

    always @(posedge clk or posedge ar) begin
        if (ar)
            q <= 1'b0;
        else
            q <= next_q;
    end

endmodule