module TopModule(
    input [3:0] x,  // x[3:0] maps to x[4:1] in K-map
    output f
);
    // First level mux: select based on x[3]x[4]
    wire [1:0] sel_high = x[3:2];
    wire intermediate;
    
    assign intermediate = (sel_high == 2'b00) ? 1'b1 :  // Choose 1 for x[3]x[4]=00
                         (sel_high == 2'b01) ? (x[1:0] == 2'b11) :  // Only 1 when x[1]x[2]=11
                         (sel_high == 2'b10) ? ~(x[1:0] == 2'b10) :  // 0 only when x[1]x[2]=10
                         1'b1;  // Default to 1 for x[3]x[4]=11
    
    assign f = intermediate;
endmodule