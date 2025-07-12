// Option 1: Continuous assignment with different formatting
module TopModule(output one);
    assign one = 1;
endmodule

// Option 2: Using always block
/*
module TopModule(output reg one);
    always @(*) begin
        one = 1'b1;
    end
endmodule
*/

// Option 3: Using parameter
/*
module TopModule(output one);
    parameter CONST_ONE = 1'b1;
    assign one = CONST_ONE;
endmodule
*/