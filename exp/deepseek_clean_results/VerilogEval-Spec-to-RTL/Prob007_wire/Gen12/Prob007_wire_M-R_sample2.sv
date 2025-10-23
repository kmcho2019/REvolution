// Wire connection implemented using always block
// Behaves identically to direct assign but shows alternative structure
module TopModule (
    input  in,
    output out
);
    reg out_reg;
    
    always @(in) begin
        out_reg = in;
    end
    
    assign out = out_reg;
endmodule