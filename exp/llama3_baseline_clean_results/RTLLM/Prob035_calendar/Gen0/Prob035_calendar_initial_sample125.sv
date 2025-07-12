module calendar(
    input CLK,
    input RST,
    output [5:0] Hours,
    output [5:0] Mins,
    output [5:0] Secs
);

reg [5:0] Secs_reg;
reg [5:0] Mins_reg;
reg [5:0] Hours_reg;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Secs_reg <= 0;
    end else if (Secs_reg == 59) begin
        Secs_reg <= 0;
    end else begin
        Secs_reg <= Secs_reg + 1;
    end
end

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Mins_reg <= 0;
    end else if (Mins_reg == 59 && Secs_reg == 59) begin
        Mins_reg <= 0;
    end else if (Secs_reg == 59) begin
        Mins_reg <= Mins_reg + 1;
    end else begin
        Mins_reg <= Mins_reg;
    end
end

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Hours_reg <= 0;
    end else if (Hours_reg == 23 && Mins_reg == 59 && Secs_reg == 59) begin
        Hours_reg <= 0;
    end else if (Mins_reg == 59 && Secs_reg == 59) begin
        Hours_reg <= Hours_reg + 1;
    end else begin
        Hours_reg <= Hours_reg;
    end
end

assign Secs = Secs_reg;
assign Mins = Mins_reg;
assign Hours = Hours_reg;

endmodule