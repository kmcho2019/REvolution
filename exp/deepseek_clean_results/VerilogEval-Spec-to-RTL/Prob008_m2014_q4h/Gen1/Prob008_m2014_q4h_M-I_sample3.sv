// Simple combinational buffer - direct input to output connection
module TopModule (
    input wire in,       // Explicit wire declaration
    output wire out      // Explicit wire declaration
);
    assign out = in;     // Direct combinational connection
endmodule