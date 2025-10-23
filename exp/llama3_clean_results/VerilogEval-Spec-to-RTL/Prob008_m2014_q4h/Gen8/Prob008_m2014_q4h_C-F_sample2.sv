// Simple combinational module that assigns input to output.
module TopModule(
    input  logic in,  
    output logic out  
);
    // Direct assignment of input to output.
    assign out = in;
endmodule