module TopModule (
    input x,
    input y,
    output reg z
);
    // Procedural implementation of XNOR operation
    always @(x or y) begin
        z = ~(x ^ y);  // Same XNOR functionality
    end
endmodule