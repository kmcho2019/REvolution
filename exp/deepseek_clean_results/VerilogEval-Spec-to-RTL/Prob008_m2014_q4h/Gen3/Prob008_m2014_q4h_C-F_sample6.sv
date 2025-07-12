// Simple combinational buffer - direct input to output
module TopModule (
    input wire in,
    output wire out
);
    assign out = in;
endmodule