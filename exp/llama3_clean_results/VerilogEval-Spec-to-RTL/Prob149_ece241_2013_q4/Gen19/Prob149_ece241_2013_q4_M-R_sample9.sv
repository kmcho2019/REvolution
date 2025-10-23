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

    reg [2:0] curr_state;
    reg [2:0] prev_state;

    always @(posedge clk) begin
        if (reset) begin
            curr_state <= 3'b000;
            prev_state <= 3'b000;
        end else begin
            prev_state <= curr_state;
            if (sensor2_asserted) curr_state <= 3'b111;
            else if (sensor1_asserted) curr_state <= 3'b011;
            else if (sensor0_asserted) curr_state <= 3'b001;
            else curr_state <= 3'b000;
        end
    end

    assign fr2 = (curr_state == 3'b000);
    assign fr1 = (curr_state == 3'b000) || (curr_state == 3'b001);
    assign fr0 = (curr_state == 3'b000) || (curr_state == 3'b001) || (curr_state == 3'b011);
    assign dfr = (curr_state > prev_state);
endmodule