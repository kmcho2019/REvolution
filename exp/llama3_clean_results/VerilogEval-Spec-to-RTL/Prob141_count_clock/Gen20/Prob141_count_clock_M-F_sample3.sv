// Define the counter modules outside of the TopModule
module sec_counter_module(
    input clk,
    input reset,
    input ena,
    output reg [5:0] counter
);
always @(posedge clk) begin
    if (reset) begin
        counter <= 'd0;
    end else if (ena) begin
        if (counter == 59) begin
            counter <= 'd0;
        end else begin
            counter <= counter + 1;
        end
    end
end
endmodule

module min_counter_module(
    input clk,
    input reset,
    input ena,
    output reg [5:0] counter
);
always @(posedge clk) begin
    if (reset) begin
        counter <= 'd0;
    end else if (ena) begin
        if (counter == 59) begin
            counter <= 'd0;
        end else begin
            counter <= counter + 1;
        end
    end
end
endmodule

module hour_counter_module(
    input clk,
    input reset,
    input ena,
    input am_pm_transition,
    output reg [4:0] counter,
    output reg am_pm
);
always @(posedge clk) begin
    if (reset) begin
        counter <= 'd0;
        am_pm <= 1'b0; // AM
    end else if (ena) begin
        if (counter == 11 && am_pm_transition) begin // Transition from PM to AM or vice versa
            counter <= 'd0;
            am_pm <= ~am_pm;
        end else if (counter == 11) begin
            counter <= 'd0;
        end else begin
            counter <= counter + 1;
        end
    end
end
endmodule

module TopModule(
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

reg [5:0] sec_counter;
reg [5:0] min_counter;
reg [4:0] hour_counter;
reg am_pm;

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
   .ena(sec_counter == 59),
   .counter(min_counter)
);

hour_counter_module hour_counter_inst(
   .clk(clk),
   .reset(reset),
   .ena(min_counter == 59 && sec_counter == 59),
   .am_pm_transition(1'b1),
   .counter(hour_counter),
   .am_pm(am_pm)
);

// Assign BCD values to output signals
always @(*) begin
    if (hour_counter == 0) begin
        hh = 8'd12;
    end else if (hour_counter < 10) begin
        hh = {4'd0, hour_counter};
    end else begin
        hh = {4'd1, hour_counter};
    end

    if (min_counter < 10) begin
        mm = {4'd0, min_counter};
    end else begin
        mm = {4'd1, min_counter[4:0] - 10};
    end

    if (sec_counter < 10) begin
        ss = {4'd0, sec_counter};
    end else begin
        ss = {4'd1, sec_counter[4:0] - 10};
    end

    pm = am_pm;
end

endmodule