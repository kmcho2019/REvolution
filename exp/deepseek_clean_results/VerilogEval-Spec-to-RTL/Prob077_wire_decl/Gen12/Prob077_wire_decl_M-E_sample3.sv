module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out,
    output out_n
);
    // Implement the logic using behavioral modeling
    always @(*) begin
        out = (a & b) | (c & d);
    end
    
    // Inverted output is a simple continuous assignment
    assign out_n = ~out;
endmodule