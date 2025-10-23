module TopModule (
    input  clk,
    input  ar,
    input  d,
    output reg q
);

    reg q_int;

    // Asynchronous reset stage: update q_int asynchronously on reset or data on clock
    always @(posedge clk or posedge ar) begin
        if (ar)
            q_int <= 1'b0;
        else
            q_int <= d;
    end

    // Synchronous output register: captures q_int on clock edge, no asynchronous reset
    always @(posedge clk) begin
        q <= q_int;
    end

endmodule