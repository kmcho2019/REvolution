module TopModule(
    input clk,
    input reset,
    input [31:0] in,
    output reg [31:0] out
);

    reg [31:0] shift_reg;

    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 32'b0;
            out <= 32'b0;
        end else begin
            shift_reg <= {in, shift_reg[31:1]};
            for (int i = 0; i < 32; i++) begin
                if (~in[i] && shift_reg[i]) begin
                    out[i] <= 1'b1;
                end
            end
        end
    end

endmodule