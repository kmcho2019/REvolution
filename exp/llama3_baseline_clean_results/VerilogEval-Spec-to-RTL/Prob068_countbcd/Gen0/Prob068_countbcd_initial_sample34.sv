module BCDCounter(
    input clk,
    input reset,
    input ena,
    output reg [3:0] q
);

    always @(posedge clk) begin
        if (reset) begin
            q <= 4'b0000;
        end else if (ena) begin
            if (q == 4'b1001) begin
                q <= 4'b0000;
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

    reg [3:0] ones;
    reg [3:0] tens;
    reg [3:0] hundreds;
    reg [3:0] thousands;

    BCDCounter onesCounter(
       .clk(clk),
       .reset(reset),
       .ena(1'b1),
       .q(ones)
    );

    BCDCounter tensCounter(
       .clk(clk),
       .reset(reset),
       .ena(ones == 4'b1001),
       .q(tens)
    );

    BCDCounter hundredsCounter(
       .clk(clk),
       .reset(reset),
       .ena(tens == 4'b1001),
       .q(hundreds)
    );

    BCDCounter thousandsCounter(
       .clk(clk),
       .reset(reset),
       .ena(hundreds == 4'b1001),
       .q(thousands)
    );

    assign ena = {hundreds == 4'b1001, tens == 4'b1001, ones == 4'b1001};
    assign q = {thousands, hundreds, tens, ones};

endmodule