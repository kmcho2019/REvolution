module TopModule (
    input  clk,
    input  ar,
    input  d,
    output reg q
);

    reg master_latch;
    reg slave_latch;

    // Master latch: transparent when clk=0
    always @(*) begin
        if (ar)
            master_latch = 1'b0;  // async reset forces zero
        else if (!clk)
            master_latch = d;
        else
            master_latch = master_latch;  // hold state
    end

    // Slave latch: transparent when clk=1
    always @(*) begin
        if (ar)
            slave_latch = 1'b0;   // async reset forces zero
        else if (clk)
            slave_latch = master_latch;
        else
            slave_latch = slave_latch;   // hold state
    end

    // Output q follows slave latch
    always @(*) begin
        q = slave_latch;
    end

endmodule