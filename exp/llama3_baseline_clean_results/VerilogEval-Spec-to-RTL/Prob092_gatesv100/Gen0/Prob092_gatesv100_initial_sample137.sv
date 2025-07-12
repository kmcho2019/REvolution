module TopModule(
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

genvar i;

generate
    // Calculate out_both
    for (i = 0; i < 100; i = i + 1) begin
        if (i == 99) begin
            assign out_both[i] = 0;
        end else begin
            assign out_both[i] = in[i] & in[i+1];
        end
    end

    // Calculate out_any
    for (i = 0; i < 100; i = i + 1) begin
        if (i == 0) begin
            assign out_any[i] = 0;
        end else begin
            assign out_any[i] = in[i] | in[i-1];
        end
    end

    // Calculate out_different
    for (i = 0; i < 100; i = i + 1) begin
        if (i == 0) begin
            assign out_different[i] = ~in[i] & in[99] | in[i] & ~in[99];
        end else begin
            assign out_different[i] = ~in[i] & in[i-1] | in[i] & ~in[i-1];
        end
    end
endgenerate

endmodule