module calendar(
    input CLK,
    input RST,
    output [5:0] Hours,
    output [5:0] Mins,
    output [5:0] Secs
);

reg [5:0] secReg;
reg [5:0] minReg;
reg [5:0] hourReg;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        secReg <= 0;
    end else if (secReg == 6'd59) begin
        secReg <= 0;
    end else begin
        secReg <= secReg + 1;
    end
end

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        minReg <= 0;
    end else if (secReg == 6'd59 && minReg == 6'd59) begin
        minReg <= 0;
    end else if (secReg == 6'd59) begin
        minReg <= minReg + 1;
    end else begin
        minReg <= minReg;
    end
end

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        hourReg <= 0;
    end else if (secReg == 6'd59 && minReg == 6'd59 && hourReg == 6'd23) begin
        hourReg <= 0;
    end else if (secReg == 6'd59 && minReg == 6'd59) begin
        hourReg <= hourReg + 1;
    end else begin
        hourReg <= hourReg;
    end
end

assign Secs = secReg;
assign Mins = minReg;
assign Hours = hourReg;

endmodule