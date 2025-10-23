module TopModule(
    input [3:0] x,  // x[3] = x[4], x[2] = x[3], x[1] = x[2], x[0] = x[1] in K-map
    output reg f
);

always @(*) begin
    case ({x[3], x[2], x[1], x[0]})
        // Group 1: Cases where f=0 (explicit 0s in K-map)
        4'b0001, 4'b0100, 4'b0110, 4'b1010: f = 0;
        
        // Group 2: Cases where f=1 (explicit 1s in K-map)
        4'b0010, 4'b0111, 4'b1000, 4'b1001, 4'b1100, 4'b1101: f = 1;
        
        // Default: Handle don't-cares as 0 for minimal implementation
        default: f = 0;
    endcase
end

endmodule