module TopModule(
    input [3:0] x,  // x[3],x[2],x[1],x[0]
    output f
);
    // Implement as 4:1 mux where select is x[3:2], data inputs are row logic
    wire [1:0] sel = x[3:2];
    wire [3:0] row_outputs;
    
    // Row 00: d,0,d,d - we'll implement as 0
    assign row_outputs[0] = 1'b0;
    
    // Row 01: 0,d,1,0
    assign row_outputs[1] = (x[1:0] == 2'b10) ? 1'b1 : 1'b0;
    
    // Row 11: 1,1,d,d - implement as 1
    assign row_outputs[2] = 1'b1;
    
    // Row 10: 1,1,0,d
    assign row_outputs[3] = (x[1:0] == 2'b10) ? 1'b0 : 1'b1;
    
    // Final 4:1 mux
    assign f = (sel == 2'b00) ? row_outputs[0] :
               (sel == 2'b01) ? row_outputs[1] :
               (sel == 2'b11) ? row_outputs[2] :
               row_outputs[3];
endmodule