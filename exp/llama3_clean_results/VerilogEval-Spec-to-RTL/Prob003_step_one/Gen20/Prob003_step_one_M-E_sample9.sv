// TopModule: Novel approach using an always block for output assignment
module TopModule (
    output one
);
    
    // Utilize an always block to set the output 'one' high
    always @(*) begin
        one = 1'b1;
    end
    
endmodule