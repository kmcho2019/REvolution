module TopModule (
    input  clk,
    input  resetn,
    input  [2:0] r,
    output [2:0] g
);

reg [1:0] state;

always @(*) begin
    if (state == 2'b00) begin
        if (r[0]) state <= 2'b01;
        else if (r[1]) state <= 2'b10;
        else if (r[2]) state <= 2'b11;
    end else if (state == 2'b01 && ~r[0]) state <= 2'b00;
    else if (state == 2'b10 && ~r[1]) state <= 2'b00;
    else if (state == 2'b11 && ~r[2]) state <= 2'b00;
end

always @(posedge clk) begin
    if (~resetn) state <= 2'b00;
    // else state <= next_state; // Removed as we're updating state directly in the combinational block
end

assign g[0] = (state == 2'b01);
assign g[1] = (state == 2'b10);
assign g[2] = (state == 2'b11);

endmodule