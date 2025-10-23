module TopModule(
    input  [3:0] x,
    output f
);
    
    assign f = (x == 4'd0) || 
               (x == 4'd9) || 
               (x == 4'd12) || 
               (x == 4'd13) || 
               (x == 4'd14) || 
               (x == 4'd15) || 
               (x == 4'd10);

endmodule