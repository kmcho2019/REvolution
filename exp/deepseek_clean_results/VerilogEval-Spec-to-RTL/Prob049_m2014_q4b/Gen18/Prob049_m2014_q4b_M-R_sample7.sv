module TopModule (
    input clk,
    input ar,
    input d,
    output q
);

wire not_clk, not_ar;
wire master_out, slave_out;
wire d_gated, reset_gated;

// Inverters for clock and reset
not (not_clk, clk);
not (not_ar, ar);

// Master latch (transparent when clk is low)
wire master_in;
and (reset_gated, slave_out, not_ar);
and (d_gated, d, not_ar);
or (master_in, reset_gated, d_gated);

wire master_latch_out;
dlatch master_latch(
    .d(master_in),
    .en(not_clk),
    .q(master_latch_out)
);

// Slave latch (transparent when clk is high)
wire slave_in;
and (slave_in, master_latch_out, not_ar);

dlatch slave_latch(
    .d(slave_in),
    .en(clk),
    .q(slave_out)
);

assign q = slave_out;

endmodule

// D-latch module
module dlatch(
    input d,
    input en,
    output q
);
    reg q_reg;
    
    always @(d or en) begin
        if (en) q_reg = d;
    end
    
    assign q = q_reg;
endmodule