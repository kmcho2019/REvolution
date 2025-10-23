module TopModule (
    input in,
    output reg out
);
    // NOT gate implemented with procedural assignment
    always @* begin
        out = ~in;
    end
endmodule