module TopModule(
    input clk,
    input reset,
    input [31:0] in,
    output reg [31:0] out
);

    reg [31:0] prev_in;
    reg [31:0] out_reg;

    always @(posedge clk) begin
        if (reset) begin
            out_reg <= 32'b0;
            prev_in <= 32'b0;
        end else begin
            prev_in <= in;
            for (int i = 0; i < 32; i++) begin
                if (prev_in[i] && !in[i]) begin
                    out_reg[i] <= 1'b1;
                end else if (reset) begin
                    out_reg[i] <= 1'b0;
                end else begin
                    out_reg[i] <= out_reg[i];
                end
            end
        end
    end

    assign out = out_reg;

endmodule