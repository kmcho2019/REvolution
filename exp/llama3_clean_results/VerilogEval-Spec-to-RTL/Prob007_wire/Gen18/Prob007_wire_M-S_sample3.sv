// Define the TopModule with the required interface and direct assignment
module TopModule(
    input  in,
    output out
);
    
    // Directly assign input to output, behaving like a wire
    assign out = in;

endmodule