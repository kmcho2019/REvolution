module TopModule (
    output zero
);
    wire not_out;
    wire const_high = 1'b1;
    
    not inv(not_out, const_high);
    and and_gate(zero, const_high, not_out);
endmodule