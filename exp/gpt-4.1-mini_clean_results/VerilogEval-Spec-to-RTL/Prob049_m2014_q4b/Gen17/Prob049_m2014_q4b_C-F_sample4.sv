module TopModule (
    input  clk,
    input  ar,      // asynchronous active-high reset
    input  d,
    output reg q
);

    // D flip-flop with asynchronous reset: 
    // on ar asserted asynchronously q resets to 0,
    // otherwise on rising edge of clk q captures d synchronously
    always @(posedge clk or posedge ar) begin
        if (ar)
            q <= 1'b0;
        else
            q <= d;
    end

endmodule