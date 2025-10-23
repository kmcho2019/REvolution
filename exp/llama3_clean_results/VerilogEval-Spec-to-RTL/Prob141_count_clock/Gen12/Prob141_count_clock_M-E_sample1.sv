// Time component module template
module time_component(
    input clk,
    input reset,
    input ena,
    output reg [3:0] tens,
    output reg [3:0] ones
);

reg [5:0] count;

always @(posedge clk) begin
    if (reset) begin
        count <= 0;
    end else if (ena) begin
        count <= count + 1;
    end
end

always @(posedge clk) begin
    if (reset) begin
        tens <= 0;
        ones <= 0;
    end else begin
        tens <= count / 10;
        ones <= count % 10;
    end
end

endmodule

// 12-hour clock hours module
module hours_module(
    input clk,
    input reset,
    input ena,
    output reg [3:0] tens,
    output reg [3:0] ones,
    output reg pm
);

reg [3:0] count;

always @(posedge clk) begin
    if (reset) begin
        count <= 0;
        pm <= 0; // AM
    end else if (ena) begin
        count <= count + 1;
        if (count == 12) begin
            pm <= 1; // PM
        end else if (count == 0) begin
            pm <= 0; // AM
        end
    end
end

always @(posedge clk) begin
    if (reset) begin
        tens <= 1;
        ones <= 2;
    end else begin
        tens <= count / 10;
        ones <= count % 10;
    end
end

endmodule

// Top-level module
module TopModule(
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

wire seconds_ena;
wire minutes_ena;

time_component seconds(
    .clk(clk),
    .reset(reset),
    .ena(ena),
    .tens(),
    .ones()
);

time_component minutes(
    .clk(clk),
    .reset(reset),
    .ena(seconds_ena),
    .tens(),
    .ones()
);

hours_module hours(
    .clk(clk),
    .reset(reset),
    .ena(minutes_ena),
    .tens(),
    .ones(),
    .pm(pm)
);

always @(posedge clk) begin
    if (reset) begin
        seconds_ena <= 0;
        minutes_ena <= 0;
    end else begin
        seconds_ena <= (seconds.count == 59) ? 1 : 0;
        minutes_ena <= (minutes.count == 59) ? 1 : 0;
    end
end

always @(posedge clk) begin
    if (reset) begin
        hh <= 8'd12; // 12
        mm <= 8'd0; // 0
        ss <= 8'd0; // 0
    end else begin
        hh <= {4'd0, hours.tens, hours.ones};
        mm <= {4'd0, minutes.tens, minutes.ones};
        ss <= {4'd0, seconds.tens, seconds.ones};
    end
end

endmodule