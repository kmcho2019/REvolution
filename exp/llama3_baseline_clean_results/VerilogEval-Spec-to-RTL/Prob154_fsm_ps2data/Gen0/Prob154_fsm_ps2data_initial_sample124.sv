module TopModule(
    input  clk,
    input  reset,
    input  [7:0] in,
    output [23:0] out_bytes,
    output done
);

reg [23:0] out_bytes_reg;
reg done_reg;
reg [1:0] counter_reg;
reg [7:0] byte1_reg;
reg [7:0] byte2_reg;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        counter_reg <= 0;
        byte1_reg <= 0;
        byte2_reg <= 0;
        out_bytes_reg <= 0;
        done_reg <= 0;
    end else begin
        done_reg <= 0;
        if (counter_reg == 0 && in[3] == 1) begin
            counter_reg <= 1;
            byte1_reg <= in;
        end else if (counter_reg == 1) begin
            counter_reg <= 2;
            byte2_reg <= in;
        end else if (counter_reg == 2) begin
            counter_reg <= 0;
            out_bytes_reg <= {byte1_reg, byte2_reg, in};
            done_reg <= 1;
        end
    end
end

assign out_bytes = out_bytes_reg;
assign done = done_reg;

endmodule