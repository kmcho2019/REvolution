module TopModule(
    input clk,
    input reset,
    input [31:0] in,
    output [31:0] out
);

reg [31:0] prev_in;
reg [31:0] captured;

always @(posedge clk) begin
    if (reset) begin
        captured <= 32'b0;
    end else begin
        prev_in <= in;
        for (int i = 0; i < 32; i++) begin
            if (prev_in[i] && !in[i]) begin
                captured[i] <= 1'b1;
            end
        end
    end
end

assign out = captured;

endmodule