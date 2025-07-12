module TopModule (
    input  wire clk,
    input  wire a,
    input  wire b,
    output wire out_assign,
    output reg  out_always_comb,
    output reg  out_always_ff
);

reg a_dly, b_dly;  // Delayed input registers for change detection
wire inputs_changed;

assign out_assign = a ^ b; // Direct behavioral assign

// Combinational always block using explicit if-else
always @(*) begin
    if (a == b)
        out_always_comb = 0;
    else
        out_always_comb = 1;
end

// Detect if inputs have changed compared to delayed version
assign inputs_changed = (a != a_dly) || (b != b_dly);

// Sequential always block with clock enable behavior
always @(posedge clk) begin
    a_dly <= a;
    b_dly <= b;
    if (inputs_changed)
        out_always_ff <= a ^ b; // Update only if inputs changed
    else
        out_always_ff <= out_always_ff; // Hold value, no toggle
end

endmodule