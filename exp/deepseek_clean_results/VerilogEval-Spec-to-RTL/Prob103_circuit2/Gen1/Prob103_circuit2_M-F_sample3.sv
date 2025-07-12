module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);
    wire all_zero = ~(a | b | c | d);
    wire all_one = a & b & c & d;
    wire adjacent_pairs = (a & b & ~c & ~d) | (~a & b & c & ~d) | (~a & ~b & c & d) | (a & ~b & ~c & d);
    wire opposite_pairs = (~a & b & c & ~d) | (a & ~b & ~c & d);
    
    assign q = all_zero | all_one | adjacent_pairs | opposite_pairs;
endmodule