module TopModule(
    input [3:0] x,  // x[3:0] represents x[4:1] in K-map (x[3]=x[4], x[2]=x[3], x[1]=x[2], x[0]=x[1])
    output reg f
);

always @(*) begin
    casez ({x[3], x[2], x[1], x[0]})
        4'b00??: f = 1'b0;  // First row with forced 0s
        4'b0100: f = 1'b0;
        4'b0110: f = 1'b0;
        4'b0111: f = 1'b1;
        4'b11??: f = 1'b1;   // Third row mostly 1s
        4'b1000: f = 1'b1;
        4'b1001: f = 1'b1;
        4'b1010: f = 1'b0;
        default: f = 1'b0;    // Safe default for remaining don't-cares
    endcase
end

endmodule