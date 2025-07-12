module TopModule (
    output reg one
);
    reg dummy;
    
    always @(*) begin
        dummy = 1'b0;  // This will be optimized away
        one = ~dummy;  // Effectively makes one = 1
    end
endmodule