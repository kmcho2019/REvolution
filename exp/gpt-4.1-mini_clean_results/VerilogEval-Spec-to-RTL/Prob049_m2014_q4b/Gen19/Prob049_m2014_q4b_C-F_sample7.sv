module DFF_AsyncReset #(
    parameter RESET_VALUE = 1'b0
)(
    input  clk,
    input  ar,         // asynchronous active-high reset
    input  d,
    output reg q
);
    // Explicit asynchronous reset wire for clarity and potential reuse
    wire async_reset = ar;

    // Asynchronous reset prioritized over data sampling
    always @(posedge clk or posedge async_reset) begin
        if (async_reset)
            q <= RESET_VALUE;
        else
            q <= d;
    end

endmodule

module TopModule (
    input  clk,
    input  ar,
    input  d,
    output q
);
    // Instantiate the parameterized DFF with asynchronous reset
    DFF_AsyncReset #(
        .RESET_VALUE(1'b0)
    ) dff_inst (
        .clk(clk),
        .ar(ar),
        .d(d),
        .q(q)
    );

endmodule