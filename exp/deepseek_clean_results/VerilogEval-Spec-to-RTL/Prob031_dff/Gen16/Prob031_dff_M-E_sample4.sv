module TopModule(
    input wire clk,
    input wire d,
    output wire q
);
    wire clk_n;
    wire master_out;
    
    // Inverted clock for master latch
    assign clk_n = ~clk;
    
    // Master latch (transparent when clk is low)
    latch master (
        .d(d),
        .en(clk_n),
        .q(master_out)
    );
    
    // Slave latch (transparent when clk is high)
    latch slave (
        .d(master_out),
        .en(clk),
        .q(q)
    );
endmodule

// Latch submodule
module latch(
    input wire d,
    input wire en,
    output reg q
);
    always @* begin
        if (en) q = d;
    end
endmodule