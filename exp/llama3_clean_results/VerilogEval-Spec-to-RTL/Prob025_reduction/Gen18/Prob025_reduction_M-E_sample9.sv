module TopModule(
    input  [7:0] in,  
    output reg parity    
);

reg [7:0] temp_in;
reg [0:0] temp_parity;
integer i;

always @(*) begin
    temp_in = in;
    temp_parity = 1'b0;
    for(i = 0; i < 8; i = i + 1) begin
        temp_parity = temp_parity ^ temp_in[i];
    end
    parity = temp_parity;
end

endmodule