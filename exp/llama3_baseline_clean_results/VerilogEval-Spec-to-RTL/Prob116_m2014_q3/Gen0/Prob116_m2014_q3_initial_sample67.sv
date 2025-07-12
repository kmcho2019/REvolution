module TopModule(
    input [3:0] x,
    output f
);

always @(x) begin
    case (x)
        4'b0000: f = 0; // As per the given K-map, can be 0 or 1 (don't care)
        4'b0001: f = 0;
        4'b0011: f = 1;
        4'b0100: f = 0;
        4'b0101: f = 0; // As per the given K-map, can be 0 or 1 (don't care)
        4'b0111: f = 1; // Direct implementation, no simplification needed
        4'b1000: f = 1;
        4'b1001: f = 1;
        4'b1011: f = 0;
        4'b1100: f = 0; // As per the given K-map, can be 0 or 1 (don't care)
        4'b1101: f = 1; // Direct implementation, no simplification needed
        4'b1111: f = 1; // Direct implementation, no simplification needed
        default: f = 0; // default case to prevent latch
    endcase
end

endmodule