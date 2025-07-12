module BCDCounter(
    input  clk,
    input  reset,
    output reg [3:0] q,
    output reg ena
);

reg [3:0] count;

always @(posedge clk) begin
    if (reset) begin
        count <= 4'd0;
    end else if (count == 4'd9) begin
        count <= 4'd0;
        ena <= 1'b1;
    end else begin
        count <= count + 1;
        ena <= 1'b0;
    end
end

assign q = count;

endmodule

module TopModule(
    input  clk,
    input  reset,
    output [2:0] ena,
    output [15:0] q
);

reg [3:0] ones_count;
reg [3:0] tens_count;
reg [3:0] hundreds_count;
reg [3:0] thousands_count;

BCDCounter ones_digit(
    .clk(clk),
    .reset(reset),
    .q(ones_count),
    .ena(ena[0])
);

BCDCounter tens_digit(
    .clk(clk),
    .reset(reset),
    .q(tens_count),
    .ena(ena[1])
);

BCDCounter hundreds_digit(
    .clk(clk),
    .reset(reset),
    .q(hundreds_count),
    .ena(ena[2])
);

BCDCounter thousands_digit(
    .clk(clk),
    .reset(reset),
    .q(thousands_count),
    .ena()
);

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

assign q[3:0] = ones_count;
assign q[7:4] = tens_count;
assign q[11:8] = hundreds_count;
assign q[15:12] = thousands_count;

endmodule