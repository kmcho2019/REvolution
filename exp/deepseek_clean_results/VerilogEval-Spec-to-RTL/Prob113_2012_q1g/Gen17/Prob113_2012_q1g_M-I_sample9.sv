module TopModule(
    input [3:0] x,
    output reg f
);
    always @(*) begin
        case (x[3:2])
            2'b00: f = (x[1:0] == 2'b00) ? 1'b1 : 
                      (x[1:0] == 2'b01) ? 1'b0 :
                      (x[1:0] == 2'b11) ? 1'b0 : 1'b1;
            2'b01: f = 1'b0;
            2'b11: f = (x[1:0] == 2'b00) ? 1'b1 :
                      (x[1:0] == 2'b01) ? 1'b1 :
                      (x[1:0] == 2'b11) ? 1'b1 : 1'b0;
            2'b10: f = (x[1:0] == 2'b00) ? 1'b1 :
                      (x[1:0] == 2'b01) ? 1'b1 :
                      (x[1:0] == 2'b11) ? 1'b0 : 1'b1;
        endcase
    end
endmodule