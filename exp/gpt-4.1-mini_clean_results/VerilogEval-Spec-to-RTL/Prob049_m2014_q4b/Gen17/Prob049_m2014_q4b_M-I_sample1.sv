module TopModule (
    input  clk,
    input  ar,    // asynchronous active-high reset
    input  d,
    output reg q
);

    // Positive edge triggered DFF with asynchronous reset
    always @(posedge clk or posedge ar) begin
        if (ar)
            q <= 1'b0;
        else
            q <= d;
    end

endmodule