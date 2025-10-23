module TopModule(
    input  in,
    output reg out
);
    
    // Procedural assignment of input to output within an always block
    always @(*) begin
        out = in;
    end

endmodule