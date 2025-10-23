module TopModule (
    input clk,
    input d,
    output reg q
);

    reg master_latch;
    reg slave_latch;

    // Master latch transparent when clk=0 (inverted clock)
    always @(*) begin
        if (~clk)
            master_latch = d;
    end

    // Slave latch transparent when clk=1
    always @(*) begin
        if (clk)
            slave_latch = master_latch;
    end

    // Output register updates on posedge clk to capture slave latch value
    always @(posedge clk) begin
        q <= slave_latch;
    end

endmodule