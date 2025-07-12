// Approach 1: Original continuous assign (optimal)
module TopModule (
    output out
);
    assign out = 1'b0;
endmodule

// Approach 2: Always block with blocking assignment
module TopModule (
    output reg out
);
    always @(*) begin
        out = 1'b0;
    end
endmodule

// Approach 3: Initial block (simulation only)
module TopModule (
    output reg out
);
    initial begin
        out = 1'b0;
    end
endmodule

// Approach 4: Parameter with conditional assignment
module TopModule (
    output out
);
    parameter ZERO = 1'b0;
    assign out = ZERO ? 1'b0 : 1'b1;
endmodule