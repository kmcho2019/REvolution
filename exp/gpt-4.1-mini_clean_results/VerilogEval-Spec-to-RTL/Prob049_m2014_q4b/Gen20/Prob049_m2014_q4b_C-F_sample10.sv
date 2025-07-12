module DFF_AsyncReset (
    input  clk,
    input  ar,       // asynchronous active-high reset
    input  d,
    output reg q
);
    // Explicit asynchronous reset signal for clarity and maintainability
    wire async_reset = ar;

    // Asynchronous reset has priority over data latch on posedge clk or async reset
    always @(posedge clk or posedge async_reset) begin
        if (async_reset)
            q <= 1'b0;  // Reset output asynchronously to 0
        else
            q <= d;     // Capture input d on rising clock edge
    end

endmodule

module TopModule (
    input  clk,
    input  ar,
    input  d,
    output q
);
    // Instantiate the D flip-flop with asynchronous reset
    DFF_AsyncReset dff_inst (
        .clk(clk),
        .ar(ar),
        .d(d),
        .q(q)
    );
endmodule