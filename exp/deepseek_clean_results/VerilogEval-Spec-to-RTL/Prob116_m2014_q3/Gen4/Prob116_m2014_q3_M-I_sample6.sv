module TopModule(
    input [3:0] x,  // x[3:0] represents x[4],x[3],x[2],x[1]
    output f
);
    // Implement using minimal SOP form derived from optimized K-map
    // f = x[4]'x[3] + x[3]x[2]' + x[4]x[1]' (after setting don't-cares to 1 where helpful)
    assign f = (~x[3] & x[2]) |  // x[4]'x[3] term (00 columns where f=1)
               (x[3] & ~x[1]) |   // x[3]x[2]' term (11 rows where f=1)
               (x[3] & ~x[0]);    // x[4]x[1]' term (10 columns where f=1)
    
    // Alternative implementation using case statement with correct bit ordering
    /*
    always @(*) begin
        case ({x[3], x[2], x[1], x[0]})  // x[4],x[3],x[2],x[1]
            // x[4]x[3] = 00
            4'b00_00: f = 1'b1;  // d -> 1
            4'b00_01: f = 1'b0;
            4'b00_11: f = 1'b1;   // d -> 1
            4'b00_10: f = 1'b1;   // d -> 1
            
            // x[4]x[3] = 01
            4'b01_00: f = 1'b0;
            4'b01_01: f = 1'b1;   // d -> 1
            4'b01_11: f = 1'b1;
            4'b01_10: f = 1'b0;
            
            // x[4]x[3] = 11
            4'b11_00: f = 1'b1;
            4'b11_01: f = 1'b1;
            4'b11_11: f = 1'b1;   // d -> 1
            4'b11_10: f = 1'b1;   // d -> 1
            
            // x[4]x[3] = 10
            4'b10_00: f = 1'b1;
            4'b10_01: f = 1'b1;
            4'b10_11: f = 1'b0;
            4'b10_10: f = 1'b1;   // d -> 1
        endcase
    end
    */
endmodule