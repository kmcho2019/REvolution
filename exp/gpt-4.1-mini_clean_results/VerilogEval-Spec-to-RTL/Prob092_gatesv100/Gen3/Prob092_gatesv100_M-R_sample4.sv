module TopModule(
    input  wire [99:0] in,
    output wire [99:0] out_both,
    output wire [99:0] out_any,
    output wire [99:0] out_different
);

genvar i;

generate
    // out_both[i] = in[i] & in[i+1] for i=0..98, out_both[99] = 0
    for (i = 0; i < 100; i = i + 1) begin : gen_out_both
        if (i < 99) begin
            assign out_both[i] = in[i] & in[i+1];
        end else begin
            assign out_both[i] = 1'b0;
        end
    end
endgenerate

generate
    // out_any[i] = in[i] | in[i-1] for i=1..99, out_any[0] = 0
    for (i = 0; i < 100; i = i + 1) begin : gen_out_any
        if (i == 0) begin
            assign out_any[i] = 1'b0;
        end else begin
            assign out_any[i] = in[i] | in[i-1];
        end
    end
endgenerate

generate
    // out_different[i] = in[i] ^ in[(i+1) mod 100]
    for (i = 0; i < 100; i = i + 1) begin : gen_out_different
        // Calculate index of neighbor to the left with wrap-around
        localparam integer left_idx = (i == 99) ? 0 : i + 1;
        assign out_different[i] = in[i] ^ in[left_idx];
    end
endgenerate

endmodule