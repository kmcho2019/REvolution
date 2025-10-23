module TopModule (
    input [2:0] vec,
    output [2:0] outv,
    output o2, o1, o0
);
    
    // Shadow register (combinational)
    reg [2:0] shadow_reg;
    
    always @(*) begin
        shadow_reg = vec;
    end
    
    // Output assignments
    assign outv = shadow_reg;
    assign o2 = shadow_reg[2];
    assign o1 = shadow_reg[1];
    assign o0 = shadow_reg[0];

endmodule