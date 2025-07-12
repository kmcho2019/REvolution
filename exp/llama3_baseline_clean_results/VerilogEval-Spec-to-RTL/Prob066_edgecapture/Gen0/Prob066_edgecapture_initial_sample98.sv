module TopModule(
    input clk,
    input reset,
    input [31:0] in,
    output [31:0] out
);

reg [31:0] prev_state;
reg [31:0] captured_state;

always @(posedge clk) begin
    if (reset) begin
        captured_state <= 32'd0;
    end else begin
        prev_state <= in;
        for (int i = 0; i < 32; i++) begin
            if (prev_state[i] == 1 && in[i] == 0) begin
                captured_state[i] <= 1;
            end
        end
    end
end

assign out = captured_state;

endmodule