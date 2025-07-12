module TopModule(
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

parameter SEC_WIDTH = 6;
parameter MIN_WIDTH = 6;
parameter HOUR_WIDTH = 5;

reg [SEC_WIDTH-1:0] sec_counter;
reg [MIN_WIDTH-1:0] min_counter;
reg [HOUR_WIDTH-1:0] hour_counter;
reg am_pm;

// Module for seconds counter
module sec_counter_module(
    input clk,
    input reset,
    input ena,
    output reg [SEC_WIDTH-1:0] counter
);
always @(posedge clk) begin
    if (reset) begin
        counter <= 'd0;
    end else if (ena) begin
        if (counter == (1 << SEC_WIDTH) - 1) begin
            counter <= 'd0;
        end else begin
            counter <= counter + 1;
        end
    end
end
endmodule

// Module for minutes counter
module min_counter_module(
    input clk,
    input reset,
    input ena,
    output reg [MIN_WIDTH-1:0] counter
);
always @(posedge clk) begin
    if (reset) begin
        counter <= 'd0;
    end else if (ena) begin
        if (counter == (1 << MIN_WIDTH) - 1) begin
            counter <= 'd0;
        end else begin
            counter <= counter + 1;
        end
    end
end
endmodule

// Module for hours counter
module hour_counter_module(
    input clk,
    input reset,
    input ena,
    output reg [HOUR_WIDTH-1:0] counter
);
always @(posedge clk) begin
    if (reset) begin
        counter <= 'd0;
    end else if (ena) begin
        if (counter == 12 - 1) begin
            counter <= 'd0;
        end else begin
            counter <= counter + 1;
        end
    end
end
endmodule

// Instantiate the counter modules
sec_counter_module sec_counter_inst(
   .clk(clk),
   .reset(reset),
   .ena(ena),
   .counter(sec_counter)
);

min_counter_module min_counter_inst(
   .clk(clk),
   .reset(reset),
   .ena(sec_counter == (1 << SEC_WIDTH) - 1),
   .counter(min_counter)
);

hour_counter_module hour_counter_inst(
   .clk(clk),
   .reset(reset),
   .ena(min_counter == (1 << MIN_WIDTH) - 1 && sec_counter == (1 << SEC_WIDTH) - 1),
   .counter(hour_counter)
);

// BCD conversion
always @(posedge clk) begin
    if (reset) begin
        am_pm <= 1'b0;
    end else if (hour_counter == 12 - 1) begin
        am_pm <= ~am_pm;
    end
end

// Assign BCD values to output signals
always @(*) begin
    if (hour_counter == 0) begin
        hh = 8'd12;
    end else if (hour_counter < 10) begin
        hh = {4'd0, hour_counter};
    end else begin
        hh = {4'd1, hour_counter - 10};
    end

    if (min_counter < 10) begin
        mm = {4'd0, min_counter};
    end else begin
        mm = {4'd1, min_counter - 10};
    end

    if (sec_counter < 10) begin
        ss = {4'd0, sec_counter};
    end else begin
        ss = {4'd1, sec_counter - 10};
    end

    pm = am_pm;
end

endmodule