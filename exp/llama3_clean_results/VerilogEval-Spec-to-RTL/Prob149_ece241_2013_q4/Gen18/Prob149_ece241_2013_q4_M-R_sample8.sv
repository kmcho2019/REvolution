module SensorModule(
    input clk,
    input reset,
    input sensor,
    output reg asserted,
    output reg prev_asserted
);
    always @(posedge clk) begin
        if (reset) begin
            asserted <= 1'b0;
            prev_asserted <= 1'b0;
        end else begin
            prev_asserted <= asserted;
            asserted <= sensor;
        end
    end
endmodule

module TopModule(
    input clk,
    input reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);
    reg sensor0_asserted;
    reg sensor0_prev_asserted;
    reg sensor1_asserted;
    reg sensor1_prev_asserted;
    reg sensor2_asserted;
    reg sensor2_prev_asserted;

    SensorModule sensor0(
        .clk(clk),
        .reset(reset),
        .sensor(s[0]),
        .asserted(sensor0_asserted),
        .prev_asserted(sensor0_prev_asserted)
    );

    SensorModule sensor1(
        .clk(clk),
        .reset(reset),
        .sensor(s[1]),
        .asserted(sensor1_asserted),
        .prev_asserted(sensor1_prev_asserted)
    );

    SensorModule sensor2(
        .clk(clk),
        .reset(reset),
        .sensor(s[2]),
        .asserted(sensor2_asserted),
        .prev_asserted(sensor2_prev_asserted)
    );

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
                dfr <= (sensor0_asserted && !sensor0_prev_asserted) || (sensor1_asserted && !sensor1_prev_asserted);
            end else if (sensor0_asserted) begin
                // Between low and lowest sensor
                fr2 <= 1'b0;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
                dfr <= (sensor0_asserted && !sensor0_prev_asserted) || (sensor1_asserted && !sensor1_prev_asserted);
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