module TopModule (
    input in1,
    input in2,
    input in3,
    output reg out
);

    wire xnor_out;
    
    assign xnor_out = ~(in1 ^ in2);  // XNOR operation
    
    always @(*) begin
        out = xnor_out ^ in3;        // XOR operation
    end

endmodule