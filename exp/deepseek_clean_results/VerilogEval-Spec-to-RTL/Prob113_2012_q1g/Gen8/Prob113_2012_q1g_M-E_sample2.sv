module TopModule(
    input [3:0] x,
    output f
);
    // Implement a 4-to-1 mux where:
    // sel = x[3:2]
    // data inputs implement the x[1:0] logic for each case
    
    wire [1:0] sel = x[3:2];
    reg out;
    
    always @(*) begin
        case(sel)
            2'b00: out = (~x[1] & ~x[0]) | (x[1] & ~x[0]);  // 0000 or 0010
            2'b01: out = 1'b0;                               // Always 0
            2'b11: out = ~x[0] | (x[1] & x[0]);             // 1100, 1101, 1111
            2'b10: out = ~x[1] | (x[1] & ~x[0]);            // 1000, 1001, 1010
        endcase
    end
    
    assign f = out;
endmodule