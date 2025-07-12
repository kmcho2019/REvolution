module TopModule (
    input in,
    output reg out
);
    always @(in) begin
        out = ~in;  // Procedural implementation of NOT gate
    end
endmodule