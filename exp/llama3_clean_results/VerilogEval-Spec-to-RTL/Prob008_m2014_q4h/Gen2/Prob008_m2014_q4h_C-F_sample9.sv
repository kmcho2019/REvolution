module TopModule(
    input  logic in, // Use 'logic' type for clarity and modern Verilog practice
    output logic out // Use 'logic' type for clarity and modern Verilog practice
);
    
    // Direct assignment is the most efficient way to implement this combinational logic
    assign out = in;
    
endmodule