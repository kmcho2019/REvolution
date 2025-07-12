module TopModule (
    input in,
    output reg out
);
    // Procedural implementation of NOT gate using always block
    always @(in) begin
        out = ~in;
    end
endmodule