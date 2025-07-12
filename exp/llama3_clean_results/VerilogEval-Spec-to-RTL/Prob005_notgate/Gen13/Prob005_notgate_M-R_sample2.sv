module TopModule(
    input  in,
    output out
);
    // This module implements a simple NOT gate using an always block for combinational logic.
    // Although less common for such simple gates, it demonstrates an alternative approach.
    always @(*) begin
        out = ~in;
    end
endmodule