module TopModule (
    input clk,
    input x,
    input [2:0] y,
    output Y0,
    output z
);

reg [2:0] current_state;

always @(posedge clk) begin
    current_state <= (x == 1'b0) ? (y == 3'b000) ? 3'b000 :
                                (y == 3'b001) ? 3'b001 :
                                (y == 3'b010) ? 3'b010 :
                                (y == 3'b011) ? 3'b001 :
                                (y == 3'b100) ? 3'b011 : current_state :
                  (x == 1'b1) ? (y == 3'b000) ? 3'b001 :
                                (y == 3'b001) ? 3'b100 :
                                (y == 3'b010) ? 3'b001 :
                                (y == 3'b011) ? 3'b010 :
                                (y == 3'b100) ? 3'b100 : current_state;
end

assign Y0 = (x == 1'b0) ? (y == 3'b000) ? 1'b0 :
                         (y == 3'b001) ? 1'b0 :
                         (y == 3'b010) ? 1'b0 :
                         (y == 3'b011) ? 1'b0 :
                         (y == 3'b100) ? 1'b0 :
             (x == 1'b1) ? (y == 3'b000) ? 1'b0 :
                         (y == 3'b001) ? 1'b0 :
                         (y == 3'b010) ? 1'b0 :
                         (y == 3'b011) ? 1'b0 :
                         (y == 3'b100) ? 1'b0 : 1'bx;

assign z = (y == 3'b011 && x == 1'b1) || (y == 3'b100 && x == 1'b0);

endmodule