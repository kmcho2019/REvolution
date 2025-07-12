module TopModule (
    input clk,
    input j,
    input k,
    output Q
);

wire Q_reg;
wire Q_next;

// Next state logic using ternary operators
assign Q_next = (j ^ k) ? j :          // Set/Reset cases
                (j & k) ? ~Q_reg :      // Toggle case
                Q_reg;                  // Hold state

// Clocked D-latch implementation using continuous assignment
assign Q_reg = clk ? Q_next : Q_reg;

// Output assignment
assign Q = Q_reg;

endmodule