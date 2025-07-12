module TopModule (
    input  clk,
    input  ar,    // Asynchronous active-high reset
    input  d,
    output q
);

// Internal signals for master and slave latch outputs
wire master_q;
reg  slave_q;

// Master latch: transparent when clk=1, latches input d
// Since standard Verilog has no built-in latch primitive, model with always @(*)
// Latch transparent when clk is high
reg master_q_reg;
always @(*) begin
    if (clk)
        master_q_reg = d;
    else
        master_q_reg = master_q;  // Hold last value when clk=0
end
assign master_q = master_q_reg;

// Slave latch: transparent when clk=0, latches master_q
// Implemented as a clocked process triggered on clk falling edge to emulate latch
// Also asynchronously reset by ar
always @(negedge clk or posedge ar) begin
    if (ar)
        slave_q <= 1'b0;     // Async reset dominates
    else
        slave_q <= master_q; // Capture master's output when clk falls (slave transparent)
end

assign q = slave_q;

endmodule