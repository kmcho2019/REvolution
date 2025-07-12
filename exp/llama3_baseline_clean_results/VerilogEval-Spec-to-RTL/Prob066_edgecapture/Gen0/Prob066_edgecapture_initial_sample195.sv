module TopModule(
    input clk,
    input reset,
    input [31:0] in,
    output reg [31:0] out
);

reg [31:0] prev_in;
reg [31:0] out_temp;

always @ (posedge clk) begin
    if (reset) begin
        out <= 32'd0;
    end else begin
        out_temp = out;
        for (int i = 0; i < 32; i++) begin
            if (prev_in[i] && !in[i]) begin
                out_temp[i] = 1'b1;
            end
        end
        out <= out_temp;
        prev_in <= in;
    end
end

endmodule