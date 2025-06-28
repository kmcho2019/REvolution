module TopModule (
  input clk,
  input x,
  input [2:0] y,
  output reg Y0,
  output reg z
);

reg [2:0] Y_next;

always @* begin
    case({y, x})
        3'b0000: Y_next = 3'b000;
        3'b0001: Y_next = 3'b001;
        3'b0010: Y_next = 3'b010;
        3'b0011: Y_next = 3'b001;
        3'b0100: Y_next = 3'b011;
        default: Y_next = 3'b000;
    endcase
    
    case(y)
        3'b011: z = 1;
        3'b100: z = 1;
        default: z = 0;
    endcase
end

always @(posedge clk) begin
    Y0 <= Y_next[0];
end

endmodule