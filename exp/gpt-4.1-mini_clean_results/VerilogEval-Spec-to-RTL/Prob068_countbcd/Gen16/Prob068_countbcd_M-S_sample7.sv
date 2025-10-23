module TopModule (
    input        clk,
    input        reset,
    output [2:0] ena,
    output [15:0] q
);

    reg [15:0] count;

    wire [3:0] ones      = count[3:0];
    wire [3:0] tens      = count[7:4];
    wire [3:0] hundreds  = count[11:8];
    wire [3:0] thousands = count[15:12];

    assign ena[0] = (ones == 4'd9);
    assign ena[1] = ena[0] && (tens == 4'd9);
    assign ena[2] = ena[1] && (hundreds == 4'd9);

    always @(posedge clk) begin
        if (reset) begin
            count <= 16'd0;
        end else begin
            if (ones != 4'd9) begin
                count[3:0] <= ones + 4'd1;
            end else begin
                count[3:0] <= 4'd0;
                if (tens != 4'd9) begin
                    count[7:4] <= tens + 4'd1;
                end else begin
                    count[7:4] <= 4'd0;
                    if (hundreds != 4'd9) begin
                        count[11:8] <= hundreds + 4'd1;
                    end else begin
                        count[11:8] <= 4'd0;
                        if (thousands != 4'd9) begin
                            count[15:12] <= thousands + 4'd1;
                        end else begin
                            count[15:12] <= 4'd0;
                        end
                    end
                end
            end
        end
    end

    assign q = count;

endmodule