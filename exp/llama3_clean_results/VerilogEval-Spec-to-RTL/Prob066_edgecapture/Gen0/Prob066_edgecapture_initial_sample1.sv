module TopModule(
    input clk,
    input reset,
    input [31:0] in,
    output reg [31:0] out
);

reg [31:0] prev_in;

always @ (posedge clk) begin
    if (reset) begin
        out <= 32'b0;
        prev_in <= 32'b0;
    end else begin
        prev_in <= in;
        for (int i = 0; i < 32; i++) begin
            if (prev_in[i] == 1 && in[i] == 0) begin
                out[i] <= 1;
            end else if (reset) begin
                out[i] <= 0;
            end else begin
                out[i] <= out[i];
            end
        end
    end
end

endmodule