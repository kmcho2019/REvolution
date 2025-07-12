// Refactored module maintaining simplicity and direct assignment.
module TopModule #(
    parameter INPUT_WIDTH = 1,
    parameter OUTPUT_WIDTH = 1
)(
    input  logic [INPUT_WIDTH-1:0] in,
    output logic [OUTPUT_WIDTH-1:0] out
);
    // Direct assignment for simplicity and efficiency.
    assign out = in;
endmodule