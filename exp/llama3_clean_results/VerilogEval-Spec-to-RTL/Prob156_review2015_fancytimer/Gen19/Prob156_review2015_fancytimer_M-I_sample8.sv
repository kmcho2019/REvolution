module PatternDetector(
    input clk,
    input reset,
    input data,
    output reg pattern_detected,
    output reg [3:0] delay
);

reg [3:0] shift_reg;
reg [3:0] bit_counter;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        shift_reg <= 0;
        bit_counter <= 0;
        pattern_detected <= 0;
        delay <= 0;
    end else begin
        if (pattern_detected == 0) begin
            shift_reg <= {shift_reg[2:0], data};
            if (shift_reg == 4'b1101) begin
                pattern_detected <= 1;
            end
        end else if (bit_counter < 4) begin
            delay <= {data, delay[3:1]};
            bit_counter <= bit_counter + 1;
            if (bit_counter == 4) begin
                pattern_detected <= 0; 
            end
        end
    end
end

endmodule

module DelayCounter(
    input clk,
    input reset,
    input enable,
    input [3:0] delay,
    output reg [19:0] counter,
    output reg [3:0] remaining_time,
    output reg counting
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        counter <= 0;
        remaining_time <= 0;
        counting <= 0;
    end else begin
        if (enable == 1'b1) begin
            counter <= (delay + 1) * 1000 - 1;
            remaining_time <= delay;
            counting <= 1;
        end else if (counting == 1'b1) begin
            if (counter > 0) begin
                counter <= counter - 1;
                if (counter % 1000 == 0) begin
                    remaining_time <= remaining_time - 1;
                end
            end else begin
                counting <= 0;
            end
        end
    end
end

endmodule

module TimeoutNotification(
    input clk,
    input reset,
    input counting,
    input ack,
    output reg done
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        done <= 0;
    end else begin
        if (counting == 1'b0 && ack == 1'b1 && done == 1'b1) begin
            done <= 0;
        end else if (counting == 1'b0 && done == 0) begin
            done <= 1;
        end
    end
end

endmodule

module TopModule(
    input clk,
    input reset,
    input data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input ack
);

reg pattern_detected;
reg [3:0] delay;
reg [19:0] counter;
reg [3:0] remaining_time;

PatternDetector pd(
    .clk(clk),
    .reset(reset),
    .data(data),
    .pattern_detected(pattern_detected),
    .delay(delay)
);

DelayCounter dc(
    .clk(clk),
    .reset(reset),
    .enable(pattern_detected), 
    .delay(delay),
    .counter(counter),
    .remaining_time(remaining_time),
    .counting(counting)
);

TimeoutNotification tn(
    .clk(clk),
    .reset(reset),
    .counting(counting),
    .ack(ack),
    .done(done)
);

assign count = remaining_time;

endmodule