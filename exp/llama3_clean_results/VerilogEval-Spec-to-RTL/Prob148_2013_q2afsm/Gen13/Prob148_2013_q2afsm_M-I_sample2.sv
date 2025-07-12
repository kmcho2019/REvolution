module TopModule(
    input  clk,
    input  resetn,
    input  [2:0] r,
    output [2:0] g
);

reg [1:0] state;
reg clk_enable;

// Clock gating
always @(posedge clk) begin
    if (~resetn) clk_enable <= 1'b0;
    else begin
        if (r[0] || r[1] || r[2]) clk_enable <= 1'b1;
        else clk_enable <= 1'b0;
    end
end

// Next state logic
always @(posedge clk) begin
    if (~resetn) state <= 2'b00;
    else if (clk_enable) begin
        case (state)
            2'b00: 
                if (r[0]) state <= 2'b01;
                else if (r[1]) state <= 2'b10;
                else if (r[2]) state <= 2'b11;
                else state <= 2'b00;
            2'b01: if (!r[0]) state <= 2'b00; else state <= 2'b01;
            2'b10: if (!r[1]) state <= 2'b00; else state <= 2'b10;
            2'b11: if (!r[2]) state <= 2'b00; else state <= 2'b11;
            default: state <= 2'b00;
        endcase
    end
end

// Output logic
assign g[0] = (state == 2'b01);
assign g[1] = (state == 2'b10);
assign g[2] = (state == 2'b11);

endmodule