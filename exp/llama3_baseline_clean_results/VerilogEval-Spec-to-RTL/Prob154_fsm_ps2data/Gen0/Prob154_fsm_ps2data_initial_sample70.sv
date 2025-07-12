module TopModule (
    input  clk,
    input  reset,
    input  [7:0] in,
    output [23:0] out_bytes,
    output done
);

reg [23:0] out_bytes_reg;
reg [1:0] counter;
reg done_reg;

always @(posedge clk) begin
    if (reset) begin
        counter <= 0;
        done_reg <= 0;
        out_bytes_reg <= 24'd0;
    end else begin
        if (counter == 0) begin
            if (in[3] == 1) begin
                out_bytes_reg[23:16] <= in;
                counter <= 1;
            end
        end else if (counter == 1) begin
            out_bytes_reg[15:8] <= in;
            counter <= 2;
        end else if (counter == 2) begin
            out_bytes_reg[7:0] <= in;
            counter <= 3;
            done_reg <= 1;
        end else if (counter == 3) begin
            counter <= 0;
            done_reg <= 0;
        end
    end
end

assign out_bytes = out_bytes_reg;
assign done = done_reg;

endmodule