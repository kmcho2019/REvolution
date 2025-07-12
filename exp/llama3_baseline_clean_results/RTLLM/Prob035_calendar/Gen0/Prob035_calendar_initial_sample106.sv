module calendar (
    input        CLK,  // Clock input
    input        RST,  // Active high reset signal
    output [5:0] Hours,  // 6-bit output representing the current hours
    output [5:0] Mins,   // 6-bit output representing the current minutes
    output [5:0] Secs    // 6-bit output representing the current seconds
);

// Initial values for hours, minutes, and seconds
reg [5:0] Hours_reg = 0;
reg [5:0] Mins_reg = 0;
reg [5:0] Secs_reg = 0;

// Assign outputs to registers
assign Hours = Hours_reg;
assign Mins = Mins_reg;
assign Secs = Secs_reg;

// Always block to update seconds
always @ (posedge CLK or posedge RST) begin
    if (RST) begin
        Secs_reg <= 0;
    end else if (Secs_reg == 59) begin
        Secs_reg <= 0;
    end else begin
        Secs_reg <= Secs_reg + 1;
    end
end

// Always block to update minutes
always @ (posedge CLK or posedge RST) begin
    if (RST) begin
        Mins_reg <= 0;
    end else if (Secs_reg == 59 && Mins_reg == 59) begin
        Mins_reg <= 0;
    end else if (Secs_reg == 59) begin
        Mins_reg <= Mins_reg + 1;
    end else begin
        Mins_reg <= Mins_reg;
    end
end

// Always block to update hours
always @ (posedge CLK or posedge RST) begin
    if (RST) begin
        Hours_reg <= 0;
    end else if (Secs_reg == 59 && Mins_reg == 59 && Hours_reg == 23) begin
        Hours_reg <= 0;
    end else if (Secs_reg == 59 && Mins_reg == 59) begin
        Hours_reg <= Hours_reg + 1;
    end else begin
        Hours_reg <= Hours_reg;
    end
end

endmodule