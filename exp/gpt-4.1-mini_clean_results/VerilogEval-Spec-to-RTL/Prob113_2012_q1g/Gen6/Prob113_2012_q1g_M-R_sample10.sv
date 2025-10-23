module TopModule(
    input  [3:0] x,
    output reg  f
);
    // Combine inputs as addr in the same order: {x[2], x[3], x[0], x[1]}
    wire [3:0] addr = {x[2], x[3], x[0], x[1]};
    
    always @(*) begin
        case (addr)
            4'd0 : f = 1'b1;
            4'd1 : f = 1'b0;
            4'd2 : f = 1'b1;
            4'd3 : f = 1'b0;
            4'd4 : f = 1'b0;
            4'd5 : f = 1'b0;
            4'd6 : f = 1'b0;
            4'd7 : f = 1'b0;
            4'd8 : f = 1'b1;
            4'd9 : f = 1'b1;
            4'd10: f = 1'b1;
            4'd11: f = 1'b0;
            4'd12: f = 1'b1;
            4'd13: f = 1'b1;
            4'd14: f = 1'b0;
            4'd15: f = 1'b1;
            default: f = 1'b0;
        endcase
    end
endmodule