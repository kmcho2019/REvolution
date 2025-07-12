module TopModule (
    input clk,
    input d,
    output q
);

wire master_out;
wire clk_n;

// Invert the clock for the master latch
not(clk_n, clk);

// Master latch (negative level-sensitive)
dlatch master (
    .d(d),
    .en(clk_n),
    .q(master_out)
);

// Slave latch (positive level-sensitive)
dlatch slave (
    .d(master_out),
    .en(clk),
    .q(q)
);

endmodule

// Level-sensitive D latch module
module dlatch (
    input d,
    input en,
    output reg q
);

always @(en or d) begin
    if (en) q <= d;
end

endmodule