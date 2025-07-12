// Simple combinational module that assigns input to output.
module TopModule(
    input  logic in,  
    output logic out  
);
assign out = in; // Direct assignment of input to output.
endmodule