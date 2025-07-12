module calendar (
    input        CLK,  // Clock input
    input        RST,  // Active high reset signal
    output [5:0] Hours,  // 6-bit output representing the current hours
    output [5:0] Mins,   // 6-bit output representing the current minutes
    output [5:0] Secs    // 6-bit output representing the current seconds
);

reg [5:0] Hours_reg;
reg [5:0] Mins_reg;
reg [5:0] Secs_reg;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Secs_reg <= 6'd0;
    end else if (Secs_reg == 6'd59) begin
        Secs_reg <= 6'd0;
    end else begin
        Secs_reg <= Secs_reg + 1'd1;
    end
end

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Mins_reg <= 6'd0;
    end else if (Secs_reg == 6'd59 && Mins_reg == 6'd59) begin
        Mins_reg <= 6'd0;
    end else if (Secs_reg == 6'd0 && Mins_reg!= 6'd59) begin
        Mins_reg <= Mins_reg;
    end else if (Secs_reg == 6'd0) begin
        Mins_reg <= 6'd0;
    end else if (Secs_reg == 6'd59) begin
        Mins_reg <= Mins_reg + 1'd1;
    end else begin
        Mins_reg <= Mins_reg;
    end
end

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Hours_reg <= 6'd0;
    end else if (Mins_reg == 6'd59 && Secs_reg == 6'd59 && Hours_reg == 6'd23) begin
        Hours_reg <= 6'd0;
    end else if (Mins_reg == 6'd59 && Secs_reg == 6'd59) begin
        Hours_reg <= Hours_reg + 1'd1;
    end else begin
        Hours_reg <= Hours_reg;
    end
end

assign Hours = Hours_reg;
assign Mins = Mins_reg;
assign Secs = Secs_reg;

endmodule