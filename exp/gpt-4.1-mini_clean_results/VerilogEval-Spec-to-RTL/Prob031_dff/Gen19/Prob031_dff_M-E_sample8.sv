module TopModule (
    input  wire clk,
    input  wire d,
    output reg  q
);

    reg master_latch;

    // Inverted clock for latch enable signals
    wire nclk = ~clk;

    // Master latch transparent when clk is low
    always @(*) begin
        if (nclk)
            master_latch = d;
        else
            master_latch = master_latch;
    end

    // Slave latch transparent when clk is high
    always @(*) begin
        if (clk)
            q = master_latch;
        else
            q = q;
    end

endmodule