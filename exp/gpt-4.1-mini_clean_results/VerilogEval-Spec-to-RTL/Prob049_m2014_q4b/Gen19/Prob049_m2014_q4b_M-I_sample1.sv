module TopModule (
    input  clk,
    input  ar,
    input  d,
    output reg q
);

    // Asynchronous active-high reset D flip-flop
    always @(posedge clk or posedge ar) begin
        if (ar)
            q <= 1'b0;
        else
            q <= d;
    end

endmodule