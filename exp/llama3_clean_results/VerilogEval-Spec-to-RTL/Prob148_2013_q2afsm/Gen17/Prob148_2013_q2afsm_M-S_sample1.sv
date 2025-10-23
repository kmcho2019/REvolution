module TopModule(
    input  clk,
    input  resetn,
    input  [2:0] r,
    output [2:0] g
);

reg [2:0] state;

always @(posedge clk) begin
    if (~resetn) state <= 3'b000;
    else case (1'b1)
        r[0] || (state == 3'b001 && r[0]): state <= 3'b001;
        r[1] && !r[0] && (state != 3'b001): state <= 3'b010;
        r[2] && !r[0] && !r[1] && (state != 3'b001) && (state != 3'b010): state <= 3'b011;
        default: state <= 3'b000;
    endcase
end

assign g[0] = (state == 3'b001);
assign g[1] = (state == 3'b010);
assign g[2] = (state == 3'b011);

endmodule