module TopModule(in, out);
    input in;
    output reg out; // Declare out as a reg to be used within always block

    always @(*) // Combinational always block sensitive to all inputs
        out = in;
endmodule