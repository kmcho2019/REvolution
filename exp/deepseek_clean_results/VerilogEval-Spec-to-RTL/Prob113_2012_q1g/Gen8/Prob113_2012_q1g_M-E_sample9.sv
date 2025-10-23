module TopModule(
    input [3:0] x,
    output reg f
);
    always @(*) begin
        case (x)
            4'b0000: f = 1;  // Top-left corner
            4'b0010: f = 1;  // Top-right corner
            4'b1000: f = 1; // Bottom-left corner
            4'b1001: f = 1; // Bottom-left corner
            4'b1010: f = 1; // Bottom-middle
            4'b1011: f = 1; // Bottom-right corner
            4'b1100: f = 1; // Middle-left
            4'b1101: f = 1; // Middle-right
            4'b1111: f = 1; // Bottom-right
            default: f = 0; // All other cases
        endcase
    end
endmodule