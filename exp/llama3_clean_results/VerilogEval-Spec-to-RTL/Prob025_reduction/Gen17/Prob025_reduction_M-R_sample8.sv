module TopModule(
    input  [7:0] in,  
    output reg parity    
);
    
always @(*) begin
    parity = ^in;
end

endmodule