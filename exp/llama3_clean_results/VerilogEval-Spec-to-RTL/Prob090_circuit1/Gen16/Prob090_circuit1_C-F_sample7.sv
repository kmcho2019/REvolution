module TopModule(a, b, q);
    input  logic a, b;
    output logic q;
    // Direct assignment for simplicity and efficiency
    assign q = a && b;
    
    // For more complex designs, consider using an always block
    // for clarity and easier management of combinational logic
    // always @(*) begin
    //     q = a & b;
    // end
endmodule