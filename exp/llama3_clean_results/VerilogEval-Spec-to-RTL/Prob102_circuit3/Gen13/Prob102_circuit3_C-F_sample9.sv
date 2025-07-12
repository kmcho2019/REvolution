module OR_Gate(
    input  a,
    input  b,
    output q
);
    // Directly implement the OR logic within this module
    assign q = a | b;
endmodule

module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);
    // Use wires to connect the outputs of OR gates to the final AND operation
    wire ab_or_result;
    wire cd_or_result;
    
    // Instantiate the OR gate modules for both pairs of inputs
    OR_Gate ab_or_gate(.a(a),.b(b),.q(ab_or_result));
    OR_Gate cd_or_gate(.a(c),.b(d),.q(cd_or_result));
    
    // Directly compute the final output using the results of the OR gates
    assign q = ab_or_result & cd_or_result;
endmodule