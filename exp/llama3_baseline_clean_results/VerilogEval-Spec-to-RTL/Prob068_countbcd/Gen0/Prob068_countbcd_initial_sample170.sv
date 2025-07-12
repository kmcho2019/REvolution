module BCDCounter(
    input clk,
    input reset,
    input ena,
    output reg [3:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 0;
    end else if (ena) begin
        if (q == 9) begin
            q <= 0;
        end else begin
            q <= q + 1;
        end
    end
end

endmodule

module TopModule(
    input clk,
    input reset,
    output reg [2:0] ena,
    output reg [15:0] q
);

reg [3:0] ones, tens, hundreds, thousands;
wire ones_ena, tens_ena, hundreds_ena;

assign ones_ena = 1'b1;
assign tens_ena = (ones == 9);
assign hundreds_ena = (tens == 9 && ones == 0);
assign ena = {hundreds_ena, tens_ena, ones_ena};

BCDCounter ones_counter(
    .clk(clk),
    .reset(reset),
    .ena(ones_ena),
    .q(ones)
);

BCDCounter tens_counter(
    .clk(clk),
    .reset(reset),
    .ena(tens_ena),
    .q(tens)
);

BCDCounter hundreds_counter(
    .clk(clk),
    .reset(reset),
    .ena(hundreds_ena),
    .q(hundreds)
);

BCDCounter thousands_counter(
    .clk(clk),
    .reset(reset),
    .ena(ones == 0 && tens == 0 && hundreds == 9),
    .q(thousands)
);

always @(posedge clk) begin
    q <= {thousands, hundreds, tens, ones};
end

endmodule