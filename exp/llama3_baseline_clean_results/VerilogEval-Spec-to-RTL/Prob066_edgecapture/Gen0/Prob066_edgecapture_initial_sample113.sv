module TopModule(
    input clk,
    input reset,
    input [31:0] in,
    output [31:0] out
);

reg [31:0] out_reg;
reg [31:0] prev_in;

always @(posedge clk) begin
    if (reset) begin
        out_reg <= 0;
    end else begin
        prev_in <= in;
    end
end

always @(*) begin
    if (reset) begin
        out <= 0;
    end else begin
        for (int i = 0; i < 32; i++) begin
            if (prev_in[i] == 1 && in[i] == 0) begin
                out_reg[i] <= 1;
            end
        end
        out <= out_reg;
    end
end

endmodule