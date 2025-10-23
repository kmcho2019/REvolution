// TopModule: Wire implementation using procedural assignment
// Demonstrates alternative coding style while maintaining identical behavior
module TopModule(input in, output out);
    reg out_reg;
    
    always @(in) begin
        out_reg = in;  // Blocking assignment for immediate propagation
    end
    
    assign out = out_reg;  // Final continuous assignment to output port
endmodule