module DFF_AsyncReset (
    input  clk,
    input  ar,    // asynchronous active-high reset
    input  d,
    output reg q
);

    wire async_reset = ar; // directly assign asynchronous reset signal

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
    // Instantiate the D flip-flop with async reset
    DFF_AsyncReset dff_inst (
        .clk(clk),
        .ar(ar),
        .d(d),
        .q(q)
    );

endmodule