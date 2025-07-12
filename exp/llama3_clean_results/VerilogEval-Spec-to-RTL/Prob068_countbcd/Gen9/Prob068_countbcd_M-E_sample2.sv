module CentralizedBCDCounter(
    input  clk,
    input  reset,
    output [2:0] ena,
    output [15:0] q
);

reg [3:0] ones_count;
reg [3:0] tens_count;
reg [3:0] hundreds_count;
reg [3:0] thousands_count;

always @(posedge clk) begin
    if (reset) begin
        ones_count <= 4'd0;
        tens_count <= 4'd0;
        hundreds_count <= 4'd0;
        thousands_count <= 4'd0;
    end else begin
        if (ones_count == 4'd9) begin
            ones_count <= 4'd0;
            if (tens_count == 4'd9) begin
                tens_count <= 4'd0;
                if (hundreds_count == 4'd9) begin
                    hundreds_count <= 4'd0;
                    if (thousands_count == 4'd9) begin
                        thousands_count <= 4'd0;
                    end else begin
                        thousands_count <= thousands_count + 1;
                    end
                end else begin
                    hundreds_count <= hundreds_count + 1;
                end
            end else begin
                tens_count <= tens_count + 1;
            end
        end else begin
            ones_count <= ones_count + 1;
        end
    end
end

assign q = {thousands_count, hundreds_count, tens_count, ones_count};
assign ena[0] = (ones_count == 4'd9) ? 1'b1 : 1'b0;
assign ena[1] = (tens_count == 4'd9 && ones_count == 4'd9) ? 1'b1 : 1'b0;
assign ena[2] = (hundreds_count == 4'd9 && tens_count == 4'd9 && ones_count == 4'd9) ? 1'b1 : 1'b0;

endmodule