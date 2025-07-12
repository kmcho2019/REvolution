module TopModule(
    input clk,
    input reset,
    input [31:0] in,
    output reg [31:0] out
);

reg [31:0] curr_state;
reg [31:0] prev_state;

always @(posedge clk) begin
    if (reset) begin
        out <= 0;
        prev_state <= 0;
    end else begin
        curr_state <= in;
        prev_state <= curr_state;

        for (int i = 0; i < 32; i++) begin
            if (prev_state[i] == 1 && curr_state[i] == 0) begin
                out[i] <= 1;
            end
        end
    end
end

endmodule