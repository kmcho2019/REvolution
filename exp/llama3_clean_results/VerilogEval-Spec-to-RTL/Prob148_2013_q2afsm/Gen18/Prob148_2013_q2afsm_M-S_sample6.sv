module TopModule(
    input  clk,
    input  resetn,
    input  [2:0] r,
    output [2:0] g
);

reg [2:0] state;

// State flip-flops
always @(posedge clk) begin
    if (~resetn) state <= 3'b000;
    else begin
        case (1'b1)
            1'b1: begin
                if (r[0]) state <= 3'b001;
                else if (r[1]) state <= 3'b010;
                else if (r[2]) state <= 3'b011;
                else state <= 3'b000;
            end
        endcase
    end
end

// Output assignments
assign g[0] = (state == 3'b001) || (state == 3'b000 && r[0]);
assign g[1] = (state == 3'b010) || (state == 3'b000 && r[1] && !r[0]);
assign g[2] = (state == 3'b011) || (state == 3'b000 && r[2] && !r[0] && !r[1]);

endmodule