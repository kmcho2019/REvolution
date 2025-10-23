module TopModule(
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

    reg [15:0] count;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 16'd0;
        end else begin
            reg [3:0] ones = count[3:0];
            reg [3:0] tens = count[7:4];
            reg [3:0] hundreds = count[11:8];
            reg [3:0] thousands = count[15:12];

            if (ones == 4'd9) begin
                ones <= 4'd0;
                if (tens == 4'd9) begin
                    tens <= 4'd0;
                    if (hundreds == 4'd9) begin
                        hundreds <= 4'd0;
                        if (thousands == 4'd9) begin
                            thousands <= 4'd0;
                        end else begin
                            thousands <= thousands + 1;
                        end
                        ena[2] <= 1'b1;
                    end else begin
                        hundreds <= hundreds + 1;
                        ena[2] <= 1'b0;
                    end
                    ena[1] <= 1'b1;
                end else begin
                    tens <= tens + 1;
                    ena[1] <= 1'b0;
                end
                ena[0] <= 1'b1;
            end else begin
                ones <= ones + 1;
                ena[0] <= 1'b0;
                ena[1] <= 1'b0;
                ena[2] <= 1'b0;
            end

            count <= {thousands, hundreds, tens, ones};
        end
    end

    assign q = count;

endmodule