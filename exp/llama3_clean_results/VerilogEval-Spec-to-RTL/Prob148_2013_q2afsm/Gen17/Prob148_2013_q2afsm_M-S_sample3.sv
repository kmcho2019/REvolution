module TopModule(
    input  clk,
    input  resetn,
    input  [2:0] r,
    output [2:0] g
);

reg [2:0] state;

// State flip-flops and state table
always @(posedge clk) begin
    if (~resetn) state <= 3'b000;
    else if (state == 3'b000) begin
        if (r[0]) state <= 3'b001;
        else if (r[1]) state <= 3'b010;
        else if (r[2]) state <= 3'b011;
    end
    else if (state == 3'b001) state <= (r[0])? 3'b001 : 3'b000;
    else if (state == 3'b010) state <= (r[1])? 3'b010 : 3'b000;
    else if (state == 3'b011) state <= (r[2])? 3'b011 : 3'b000;
end

// Output assignments
assign g[0] = (state == 3'b001);
assign g[1] = (state == 3'b010);
assign g[2] = (state == 3'b011);

endmodule