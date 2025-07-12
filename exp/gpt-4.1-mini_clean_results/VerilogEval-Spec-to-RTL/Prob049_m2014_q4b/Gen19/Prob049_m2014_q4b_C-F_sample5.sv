module DFF_AsyncReset (
    input  clk,
    input  ar,       // asynchronous active-high reset
    input  d,
    output reg q
);
    // Explicit asynchronous reset wire for clarity and possible reuse
    wire async_reset = ar;

    // Asynchronous reset has priority over data sampling
    always @(posedge clk or posedge async_reset) begin
        if (async_reset)
            q <= 1'b0;
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
    // Instantiate the DFF with asynchronous reset submodule
    DFF_AsyncReset dff_inst (
        .clk(clk),
        .ar(ar),
        .d(d),
        .q(q)
    );
endmodule