module TopModule #(
    parameter INPUT_WIDTH = 8,
    parameter OUTPUT_WIDTH = 32
) (
    input  [INPUT_WIDTH-1:0] in,
    output [OUTPUT_WIDTH-1:0] out
);

    // Check if input width is not greater than output width
    initial begin
        if (INPUT_WIDTH > OUTPUT_WIDTH) begin
            $display("Warning: Input width is greater than output width.");
        end
    end

    // Calculate the number of bits to replicate
    localparam REPLICATION_BITS = OUTPUT_WIDTH - INPUT_WIDTH;

    // Use the replication operator to fill out with the sign bit of in
    assign out = {REPLICATION_BITS{in[INPUT_WIDTH-1]}, in};

    // This structure maintains the simplicity and efficiency of the original design
    // but introduces a new level of flexibility and scalability.

endmodule