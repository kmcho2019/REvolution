module TopModule(
    input clk,
    input reset,
    input [31:0] in,
    output reg [31:0] out
);

    reg [31:0] prev_state;
    reg [31:0] flag;

    always @(posedge clk) begin
        if (reset) begin
            prev_state <= 32'b0;
            flag <= 32'b0;
            out <= 32'b0;
        end else begin
            prev_state <= in;
            for (int i = 0; i < 32; i++) begin
                if (~in[i] && prev_state[i]) begin
                    flag[i] <= 1'b1;
                end
            end
            out <= flag;
        end
    end

endmodule