module TopModule (
    input clk,
    input ar,
    input d,
    output q
);

wire not_clk, not_ar;
wire master_out, slave_in;
wire reset_path;

// Inverters for clock and reset
not (not_clk, clk);
not (not_ar, ar);

// Reset path - forces output low when ar is high
and (reset_path, not_ar, q);

// Master latch (transparent when clock is low)
wire master_and, master_feedback;
and (master_and, d, not_clk);
or (master_out, master_and, master_feedback);
not (master_feedback, master_out);

// Slave latch (transparent when clock is high)
wire slave_and, slave_feedback;
and (slave_in, master_out, clk);
or (slave_out, slave_in, slave_feedback);
not (slave_feedback, slave_out);

// Final output with reset override
and (q, slave_out, not_ar);

endmodule