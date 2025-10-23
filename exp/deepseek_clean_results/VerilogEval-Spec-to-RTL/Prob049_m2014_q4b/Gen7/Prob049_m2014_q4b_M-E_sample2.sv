module AsyncResetLatch(
    input en,
    input ar,
    input d,
    output reg q
);
    always @(en or ar or d)
        if (ar) q <= 1'b0;
        else if (en) q <= d;
endmodule

module TopModule(
    input clk,
    input ar,
    input d,
    output q
);
    wire master_out;
    
    // Master latch (active when clock is low)
    AsyncResetLatch master(
        .en(~clk),
        .ar(ar),
        .d(d),
        .q(master_out)
    );
    
    // Slave latch (active when clock is high)
    AsyncResetLatch slave(
        .en(clk),
        .ar(ar),
        .d(master_out),
        .q(q)
    );
endmodule