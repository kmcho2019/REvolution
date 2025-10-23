module TopModule(
    input clk,
    input reset,
    input [31:0] in,
    output reg [31:0] out
);

    reg [31:0] shift_reg;

    always @(posedge clk) begin
        if (reset) begin
            out <= 32'b0;
            shift_reg <= 32'b0;
        end else begin
            shift_reg <= in;
            for (int i = 0; i < 32; i++) begin
                if (~in[i] && shift_reg[i]) begin
                    out[i] <= 1'b1;
                end else if (reset) begin
                    out[i] <= 1'b0;
                end
            end
        end
    end

endmodule