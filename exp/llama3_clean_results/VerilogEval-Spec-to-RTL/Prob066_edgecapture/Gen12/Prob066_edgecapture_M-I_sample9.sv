module TopModule(
    input clk,
    input reset,
    input [31:0] in,
    output reg [31:0] out
);

    reg [31:0] prev_in;

    initial begin
        out = 32'b0;
        prev_in = 32'b0;
    end

    always @(posedge clk) begin
        if (reset) begin
            out <= 32'b0;
            prev_in <= 32'b0;
        end else begin
            prev_in <= in;
            for (int i = 0; i < 32; i = i + 1) begin
                if (out[i] || (prev_in[i] && !in[i])) begin
                    out[i] <= 1'b1;
                end else begin
                    out[i] <= out[i]; // No change if not set and no transition
                end
            end
        end
    end

endmodule