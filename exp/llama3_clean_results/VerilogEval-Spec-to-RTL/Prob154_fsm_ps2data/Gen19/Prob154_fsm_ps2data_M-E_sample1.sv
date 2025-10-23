module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

reg [7:0] stage1_out;
reg [7:0] stage2_out;
reg [23:0] out_bytes_reg;
reg done_reg;

always @(posedge clk) begin
    if (reset) begin
        stage1_out <= 0;
        stage2_out <= 0;
        out_bytes_reg <= 0;
        done_reg <= 0;
    end else begin
        // Stage 1: Detect start of message
        if (in[3]) begin
            stage1_out <= in;
        end else begin
            stage1_out <= 0;
        end

        // Stage 2: Shift input bytes into out_bytes register
        if (stage1_out!= 0) begin
            stage2_out <= stage1_out;
            out_bytes_reg[23:16] <= stage1_out;
        end else if (stage2_out!= 0) begin
            out_bytes_reg[15:8] <= stage2_out;
            stage2_out <= in;
        end else begin
            stage2_out <= 0;
        end

        // Stage 3: Signal completion of message
        if (out_bytes_reg[7:0] == 0 && stage2_out!= 0) begin
            out_bytes_reg[7:0] <= in;
            done_reg <= 1;
        end else begin
            done_reg <= 0;
        end
    end
end

assign out_bytes = out_bytes_reg;
assign done = done_reg;

endmodule