module TopModule(
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    assign out_both[99] = 1'b0; // since in[99] has no neighbor to the left
    assign out_any[0] = 1'b0; // since in[0] has no neighbor to the right

    for (genvar i = 0; i < 100; i++) begin
        if (i < 99) begin
            assign out_both[i] = in[i] & in[i+1];
            assign out_any[i] = in[i] | in[i-1];
            assign out_different[i] = in[i] ^ in[i+1];
        end
        else begin
            assign out_different[99] = in[99] ^ in[0];
        end
    end

endmodule