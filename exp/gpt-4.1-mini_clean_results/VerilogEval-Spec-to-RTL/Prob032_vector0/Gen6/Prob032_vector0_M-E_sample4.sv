module BitExtractor #(parameter BIT_IDX = 0) (
    input  [2:0] vec,
    output       out_bit
);
    assign out_bit = vec[BIT_IDX];
endmodule

module TopModule (
    input  [2:0] vec,
    output [2:0] outv,
    output       o2,
    output       o1,
    output       o0
);
    // Extract each bit using parameterized modules
    BitExtractor #(.BIT_IDX(0)) extractor0 (.vec(vec), .out_bit(o0));
    BitExtractor #(.BIT_IDX(1)) extractor1 (.vec(vec), .out_bit(o1));
    BitExtractor #(.BIT_IDX(2)) extractor2 (.vec(vec), .out_bit(o2));

    // Compose outv from extracted bits
    assign outv = {o2, o1, o0};

endmodule