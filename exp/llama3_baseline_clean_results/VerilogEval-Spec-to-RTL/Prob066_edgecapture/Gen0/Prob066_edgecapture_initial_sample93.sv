module TopModule(
    input clk,
    input reset,
    input [31:0] in,
    output reg [31:0] out
);

reg [31:0] prev_in;
reg [31:0] flag;

always @(posedge clk) begin
    if (reset) begin
        flag <= 32'd0;
        prev_in <= 32'd0;
    end else begin
        prev_in <= in;
        for (int i = 0; i < 32; i++) begin
            if (prev_in[i] && !in[i]) begin
                flag[i] <= 1'b1;
            end
        end
    end
end

always @(*) begin
    out = flag;
end

endmodule