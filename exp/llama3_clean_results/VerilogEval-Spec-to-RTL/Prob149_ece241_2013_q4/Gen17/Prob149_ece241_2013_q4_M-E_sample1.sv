module TopModule(
    input clk,
    input reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

// Sensor module for each sensor
module SensorModule(
    input clk,
    input reset,
    input sensor,
    output reg asserted
);
    reg prev_sensor;
    always @(posedge clk) begin
        if (reset) begin
            asserted <= 1'b0;
            prev_sensor <= 1'b0;
        end else begin
            prev_sensor <= sensor;
            if (sensor) begin
                asserted <= 1'b1;
            end else if (!sensor && prev_sensor) begin
                asserted <= 1'b0;
            end
        end
    end
endmodule

// Instantiate sensor modules for each sensor
SensorModule sensor0(
   .clk(clk),
   .reset(reset),
   .sensor(s[0]),
   .asserted(sensor0_asserted)
);

SensorModule sensor1(
   .clk(clk),
   .reset(reset),
   .sensor(s[1]),
   .asserted(sensor1_asserted)
);

SensorModule sensor2(
   .clk(clk),
   .reset(reset),
   .sensor(s[2]),
   .asserted(sensor2_asserted)
);

// Main state machine
always @(posedge clk) begin
    if (reset) begin
        fr2 <= 1'b1;
        fr1 <= 1'b1;
        fr0 <= 1'b1;
        dfr <= 1'b1;
    end else begin
        if (sensor2_asserted && sensor1_asserted && sensor0_asserted) begin
            // Above high sensor
            fr2 <= 1'b0;
            fr1 <= 1'b0;
            fr0 <= 1'b0;
            dfr <= 1'b0;
        end else if (sensor1_asserted && sensor0_asserted) begin
            // Between high and low sensor
            fr2 <= 1'b0;
            fr1 <= 1'b0;
            fr0 <= 1'b1;
            dfr <= 1'b1;
        end else if (sensor0_asserted) begin
            // Between low and lowest sensor
            fr2 <= 1'b0;
            fr1 <= 1'b1;
            fr0 <= 1'b1;
            dfr <= 1'b1;
        end else begin
            // Below lowest sensor
            fr2 <= 1'b1;
            fr1 <= 1'b1;
            fr0 <= 1'b1;
            dfr <= 1'b1;
        end
    end
end

endmodule