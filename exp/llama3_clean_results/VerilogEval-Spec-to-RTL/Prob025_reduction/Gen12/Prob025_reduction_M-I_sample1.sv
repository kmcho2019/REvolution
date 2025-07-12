module TopModule(
    input  [7:0] in,  
    output parity    
);

// Use a loop to perform a bitwise XOR operation
reg [7:0] temp;
integer i;
always @(*) begin
    temp = 8'b0;
    for (i = 0; i < 8; i++) begin
        temp = temp ^ in[i];
    end
    parity = temp[0];
end

endmodule