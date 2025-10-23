module TopModule(
    input  [7:0] in,  
    output reg parity    
);

always @(*) begin
    parity = 1'b0;
    for (int i = 0; i < 8; i++) begin
        parity = parity ^ in[i];
    end
end

endmodule