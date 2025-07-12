module TopModule (
    output one
);
    parameter CONST_VAL = 1'b1;
    reg [0:0] mem;
    
    initial begin
        mem = CONST_VAL;
    end
    
    assign one = mem;
endmodule