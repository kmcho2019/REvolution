module TopModule (
    input  clk,
    input  ar,
    input  d,
    output reg q
);

    reg q_async_reset;

    // Asynchronous reset process: asynchronously clear q_async_reset on ar
    always @(posedge clk or posedge ar) begin
        if (ar)
            q_async_reset <= 1'b0;
        else
            q_async_reset <= d;
    end

    // Output register follows q_async_reset directly
    always @(ar or q_async_reset) begin
        if (ar)
            q <= 1'b0;
        else
            q <= q_async_reset;
    end

endmodule