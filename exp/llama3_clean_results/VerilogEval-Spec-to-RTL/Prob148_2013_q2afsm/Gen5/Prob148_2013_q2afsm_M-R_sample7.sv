module TopModule(
    input  clk,
    input  resetn,
    input  [2:0] r,
    output [2:0] g
);

reg [2:0] state;

always @(posedge clk) begin
    if (~resetn) state <= 3'b000;
    else begin
        case (state)
            3'b000: begin
                if (r[0]) state <= 3'b001;
                else if (r[1]) state <= 3'b010;
                else if (r[2]) state <= 3'b011;
            end
            3'b001: begin
                if (!r[0]) state <= 3'b000;
            end
            3'b010: begin
                if (!r[1]) state <= 3'b000;
            end
            3'b011: begin
                if (!r[2]) state <= 3'b000;
            end
            default: state <= 3'b000;
        endcase
    end
end

assign g[0] = (state == 3'b001);
assign g[1] = (state == 3'b010);
assign g[2] = (state == 3'b011);

endmodule