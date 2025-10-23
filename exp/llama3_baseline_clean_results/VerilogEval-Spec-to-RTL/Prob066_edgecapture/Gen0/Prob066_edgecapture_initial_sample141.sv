module TopModule (
    input        clk,
    input        reset,
    input  [31:0] in,
    output [31:0] out
);

reg [31:0] prev_state;
reg [31:0] out_reg;

always @(posedge clk) begin
    if (reset) begin
        prev_state <= 32'd0;
        out_reg <= 32'd0;
    end else begin
        prev_state <= in;
        for (int i = 0; i < 32; i++) begin
            if (prev_state[i] && !in[i]) begin
                out_reg[i] <= 1'b1;
            end
        end
    end
end

assign out = out_reg;

endmodule