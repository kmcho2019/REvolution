`default_nettype none

module Latch(
    input wire en,
    input wire d,
    output reg q
);
    always @(*) begin
        if (en) q = d;
    end
endmodule

module TopModule(
    input wire clk,
    input wire d,
    output wire q
);
    wire master_out;
    wire clk_n = ~clk;  // Generate inverted clock
    
    // Master latch (transparent when clock is low)
    Latch master_latch(
        .en(clk_n),
        .d(d),
        .q(master_out)
    );
    
    // Slave latch (transparent when clock is high)
    Latch slave_latch(
        .en(clk),
        .d(master_out),
        .q(q)
    );
endmodule

`default_nettype wire