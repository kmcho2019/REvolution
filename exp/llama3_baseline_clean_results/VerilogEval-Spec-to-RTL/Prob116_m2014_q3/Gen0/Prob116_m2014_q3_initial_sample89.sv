module TopModule(
    input  [3:0] x,
    output reg f
);

always @(*) begin
    case ({x[3], x[2], x[1], x[0]})
        4'b0101, 4'b0111, 4'b1101, 4'b1111, 4'b1011: f = 1'b1;
        4'b0100, 4'b0110, 4'b1000: f = 1'b0;
        default: f = 1'b0; // Assigning 0 for don't care conditions
    endcase
end

endmodule