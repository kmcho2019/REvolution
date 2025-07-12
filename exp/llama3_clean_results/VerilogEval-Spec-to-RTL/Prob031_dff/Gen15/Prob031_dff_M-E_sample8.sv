module TopModule(
    input clk,
    input d,
    output reg q
);

// Master latch
reg master_latch;

// Always block for the master latch
always @(*)
begin
    if (clk)
        master_latch = d;
    else
        master_latch = master_latch;
end

// Slave latch
reg slave_latch;

// Always block for the slave latch
always @(posedge clk)
begin
    slave_latch = master_latch;
    q = slave_latch;
end

endmodule