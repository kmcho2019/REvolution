module calendar(
    input CLK,    // Clock input
    input RST,    // Active high reset signal
    output [5:0] Hours,  // 6-bit output representing the current hours
    output [5:0] Mins,  // 6-bit output representing the current minutes
    output [5:0] Secs   // 6-bit output representing the current seconds
);

reg [5:0] Hours_reg;  // internal register for hours
reg [5:0] Mins_reg;  // internal register for minutes
reg [5:0] Secs_reg;  // internal register for seconds

// Update seconds value
always @(posedge CLK or posedge RST) begin
    if (RST) begin  // if reset signal is active
        Secs_reg <= 6'd0;  // set seconds value to 0
    end else if (Secs_reg == 6'd59) begin  // if seconds value is 59
        Secs_reg <= 6'd0;  // wrap around to 0
    end else begin
        Secs_reg <= Secs_reg + 6'd1;  // increment seconds value by 1
    end
end

// Update minutes value
always @(posedge CLK or posedge RST) begin
    if (RST) begin  // if reset signal is active
        Mins_reg <= 6'd0;  // set minutes value to 0
    end else if (Secs_reg == 6'd59 && Mins_reg == 6'd59) begin  // if seconds and minutes values are both 59
        Mins_reg <= 6'd0;  // wrap around to 0
    end else if (Secs_reg == 6'd59) begin  // if seconds value is 59
        Mins_reg <= Mins_reg + 6'd1;  // increment minutes value by 1
    end else begin
        Mins_reg <= Mins_reg;  // keep minutes value unchanged
    end
end

// Update hours value
always @(posedge CLK or posedge RST) begin
    if (RST) begin  // if reset signal is active
        Hours_reg <= 6'd0;  // set hours value to 0
    end else if (Mins_reg == 6'd59 && Secs_reg == 6'd59 && Hours_reg == 6'd23) begin  // if hours, minutes, and seconds values are all at their maximum
        Hours_reg <= 6'd0;  // wrap around to 0
    end else if (Mins_reg == 6'd59 && Secs_reg == 6'd59) begin  // if minutes and seconds values are both 59
        Hours_reg <= Hours_reg + 6'd1;  // increment hours value by 1
    end else begin
        Hours_reg <= Hours_reg;  // keep hours value unchanged
    end
end

assign Hours = Hours_reg;  // assign internal hours register to output
assign Mins = Mins_reg;  // assign internal minutes register to output
assign Secs = Secs_reg;  // assign internal seconds register to output

endmodule