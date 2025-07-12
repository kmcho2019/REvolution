module TopModule (
    input clk,
    input d,
    input q, // Note: input q here used to generate asynchronous reset internally, no conflict with output q
    output reg q_out
);

    wire async_reset = q; // Asynchronous reset is active when input q is high

    always @(posedge clk or posedge async_reset) begin
        if (async_reset)
            q_out <= 1'b0; // Asynchronous reset to 0
        else
            q_out <= d;    // Normal D flip-flop operation
    end

endmodule