module TopModule (
    input [2:0] vec,
    output [2:0] outv,
    output o2, o1, o0
);

    reg [2:0] temp_reg;
    
    always @(*) begin
        temp_reg = vec;
    end
    
    assign outv = temp_reg;
    assign o2 = temp_reg[2];
    assign o1 = temp_reg[1];
    assign o0 = temp_reg[0];

endmodule