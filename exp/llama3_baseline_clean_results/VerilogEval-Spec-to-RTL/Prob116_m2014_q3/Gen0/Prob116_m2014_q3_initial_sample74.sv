module TopModule (
    input [3:0] x,
    output f
);

always @(x) begin
    case (x)
        4'b0000, 4'b0001, 4'b0100, 4'b1000, 4'b1001, 4'b1100, 4'b1101, 4'b1111: 
            f = (x[3] && x[2]) || (x[3] && x[1]) || (x[2] && x[1] && x[0]);
        default: 
            f = 0;
    endcase
end

endmodule