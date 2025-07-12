module TopModule(
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    // Initialize out_both
    assign out_both[99] = 1'b0; // MSB has no left neighbor
    for (genvar i = 0; i < 99; i++) begin
        assign out_both[i] = in[i] & in[i+1];
    end

    // Initialize out_any
    assign out_any[0] = 1'b0; // LSB has no right neighbor
    for (genvar i = 1; i < 100; i++) begin
        assign out_any[i] = in[i] | in[i-1];
    end

    // Initialize out_different
    for (genvar i = 0; i < 99; i++) begin
        assign out_different[i] = in[i] ^ in[i+1];
    end
    assign out_different[99] = in[99] ^ in[0]; // MSB wraps around to LSB

endmodule