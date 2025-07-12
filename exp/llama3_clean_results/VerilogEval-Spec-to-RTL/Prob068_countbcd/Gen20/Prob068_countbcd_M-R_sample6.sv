module BCDCounter(
    input  clk,
    input  reset,
    input  ena,
    output [3:0] q
);

reg [3:0] count;

always @(posedge clk) begin
    if (reset) begin
        count <= 4'd0;
    end else if (ena) begin
        if (count == 4'd9) begin
            count <= 4'd0;
        end else begin
            count <= count + 1;
        end
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

wire [3:0] ones_ena;
wire [3:0] tens_ena;
wire [3:0] hundreds_ena;
wire [3:0] thousands_ena;

BCDCounter ones_counter(
    .clk(clk),
    .reset(reset),
    .ena(1'b1),
    .q(q[3:0])
);

BCDCounter tens_counter(
    .clk(clk),
    .reset(reset),
    .ena(q[3:0] == 4'd9),
    .q(q[7:4])
);

BCDCounter hundreds_counter(
    .clk(clk),
    .reset(reset),
    .ena((q[3:0] == 4'd9) && (q[7:4] == 4'd9)),
    .q(q[11:8])
);

BCDCounter thousands_counter(
    .clk(clk),
    .reset(reset),
    .ena((q[3:0] == 4'd9) && (q[7:4] == 4'd9) && (q[11:8] == 4'd9)),
    .q(q[15:12])
);

assign ena[0] = q[3:0] == 4'd9;
assign ena[1] = (q[3:0] == 4'd9) && (q[7:4] == 4'd9);
assign ena[2] = (q[3:0] == 4'd9) && (q[7:4] == 4'd9) && (q[11:8] == 4'd9);

endmodule