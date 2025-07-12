module TopModule(
    input  logic in, // Use 'logic' type for clarity
    output logic out // Use 'logic' type for clarity
);
    
    assign out = in; // Continuous assignment remains the most efficient way
    
endmodule