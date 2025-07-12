module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

wire rollover = (q == 4'b1001);
wire clk_en = ~rollover;
reg gated_clk;

always @(*) begin
    gated_clk = clk & clk_en;
end

always @(posedge gated_clk or posedge reset) begin
    if (reset) begin
        q <= 4'b0000;
    end
    else begin
        if (rollover) begin
            q <= 4'b0000;
        end
        else begin
            q <= q + 1'b1;
        end
    end
end

endmodule