module TopModule(
    input  [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    // Calculate out_both
    assign out_both[99] = 1'b0; // Most significant bit has no neighbour to the left
    for (genvar i = 98; i >= 0; i--) begin
        assign out_both[i] = in[i] & in[i+1]; // Check if current bit and its neighbour to the left are both '1'
    end

    // Calculate out_any
    assign out_any[0] = 1'b0; // Least significant bit has no neighbour to the right
    for (genvar i = 1; i <= 99; i++) begin
        assign out_any[i] = in[i] | in[i-1]; // Check if current bit or its neighbour to the right is '1'
    end

    // Calculate out_different
    for (genvar i = 0; i <= 98; i++) begin
        assign out_different[i] = ~(in[i] ^ in[i+1]); // Check if current bit is different from its neighbour to the left
    end
    assign out_different[99] = ~(in[99] ^ in[0]); // Most significant bit wraps around to least significant bit

endmodule