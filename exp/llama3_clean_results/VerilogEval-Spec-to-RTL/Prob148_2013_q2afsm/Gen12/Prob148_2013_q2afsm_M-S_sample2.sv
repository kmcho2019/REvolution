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
            3'b000: 
                if (r[0]) state <= 3'b001;
                else if (r[1]) state <= 3'b010;
                else if (r[2]) state <= 3'b011;
            3'b001: 
                if (!r[0]) state <= 3'b000;
            3'b010: 
                if (!r[1]) state <= 3'b000;
            3'b011: 
                if (!r[2]) state <= 3'b000;
            default: state <= 3'b000;
        endcase
    end
end

assign g[0] = (state == 3'b001);
assign g[1] = (state == 3'b010);
assign g[2] = (state == 3'b011);

endmodule