module TopModule(
    input  [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    // Generate out_both
    assign out_both[99] = 1'b0; // since there's no left neighbour
    for (genvar i = 98; i >= 0; i--) begin
        assign out_both[i] = in[i] & in[i+1];
    end

    // Generate out_any
    assign out_any[0] = 1'b0; // since there's no right neighbour
    for (genvar i = 1; i <= 99; i++) begin
        assign out_any[i] = in[i] | in[i-1];
    end

    // Generate out_different
    for (genvar i = 98; i >= 0; i--) begin
        assign out_different[i] = in[i] ^ in[i+1];
    end
    assign out_different[99] = in[99] ^ in[0]; // wrap around

endmodule