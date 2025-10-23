module TopModule (
    input a,
    input b,
    output q
);
    reg a_prev, b_prev;
    
    always @(*) begin
        q = a & b & a_prev & b_prev;
    end
    
    always @(posedge a or posedge b) begin
        a_prev <= a;
        b_prev <= b;
    end
endmodule