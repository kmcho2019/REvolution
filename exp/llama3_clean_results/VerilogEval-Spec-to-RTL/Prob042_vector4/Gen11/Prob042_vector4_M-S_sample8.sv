module TopModule #(
    parameter REPLICATION_COUNT = 24,
    parameter INPUT_WIDTH = 8,
    parameter OUTPUT_WIDTH = 32
) (
    input [INPUT_WIDTH-1:0] in,
    output [OUTPUT_WIDTH-1:0] out
);
    
    // Directly assign the replicated MSB concatenated with the input to the output
    assign out = {{REPLICATION_COUNT{in[INPUT_WIDTH-1]}}, in};

endmodule