module TopModule(
    input  clk,
    input  reset,
    output [2:0] ena,
    output [15:0] q
);

    reg [3:0] digit1, digit2, digit3, digit4;
    reg [2:0] ena;

    always @(posedge clk) begin
        if (reset) begin
            digit1 <= 4'd0;
            digit2 <= 4'd0;
            digit3 <= 4'd0;
            digit4 <= 4'd0;
        end else begin
            if (digit1 == 4'd9) begin
                digit1 <= 4'd0;
                if (digit2 == 4'd9) begin
                    digit2 <= 4'd0;
                    if (digit3 == 4'd9) begin
                        digit3 <= 4'd0;
                        if (digit4 == 4'd9) begin
                            digit4 <= 4'd0;
                        end else begin
                            digit4 <= digit4 + 1;
                        end
                    end else begin
                        digit3 <= digit3 + 1;
                    end
                end else begin
                    digit2 <= digit2 + 1;
                end
            end else begin
                digit1 <= digit1 + 1;
            end
        end
    end

    always @(*) begin
        q <= {digit4, digit3, digit2, digit1};
        ena[0] = (digit1 == 4'd9);
        ena[1] = (digit1 == 4'd9) && (digit2 == 4'd9);
        ena[2] = (digit1 == 4'd9) && (digit2 == 4'd9) && (digit3 == 4'd9);
    end

endmodule