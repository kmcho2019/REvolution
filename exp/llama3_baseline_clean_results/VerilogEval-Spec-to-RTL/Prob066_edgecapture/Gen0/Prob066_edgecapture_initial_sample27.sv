module TopModule(
    input clk,
    input reset,
    input [31:0] in,
    output [31:0] out
);

reg [31:0] current_state;
reg [31:0] captured_state;

always @(posedge clk) begin
    if (reset) begin
        captured_state <= 32'd0;
    end else begin
        for (int i = 0; i < 32; i++) begin
            if (current_state[i] && !in[i]) begin
                captured_state[i] <= 1'b1;
            end
        end
    end
end

always @(posedge clk) begin
    current_state <= in;
end

assign out = captured_state;

endmodule