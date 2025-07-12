module TopModule(
    input clk,
    input reset,
    input data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input ack
);

// Pattern detection module
reg [3:0] pattern_reg;
reg pattern_detected;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        pattern_reg <= 4'd0;
        pattern_detected <= 1'b0;
    end
    else begin
        pattern_reg <= {pattern_reg[2:0], data};
        if (pattern_reg == 4'b1101) begin
            pattern_detected <= 1'b1;
        end
        else if (pattern_detected) begin
            pattern_detected <= 1'b0;
        end
    end
end

// Delay detection module
reg [3:0] delay_reg;
reg delay_detected;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        delay_reg <= 4'd0;
        delay_detected <= 1'b0;
    end
    else if (pattern_detected) begin
        delay_reg <= {delay_reg[2:0], data};
        if (delay_reg[3]) begin
            delay_detected <= 1'b1;
        end
    end
    else if (delay_detected) begin
        delay_detected <= 1'b0;
    end
end

// Counting module
reg [19:0] counter;
reg counting_enabled;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        counter <= 20'd0;
        counting_enabled <= 1'b0;
    end
    else if (delay_detected) begin
        counter <= (delay_reg + 1) * 1000 - 1;
        counting_enabled <= 1'b1;
    end
    else if (counting_enabled) begin
        if (counter > 20'd0) begin
            counter <= counter - 1;
        end
        else begin
            counting_enabled <= 1'b0;
        end
    end
end

// Output logic
always @(posedge clk) begin
    if (counting_enabled) begin
        count <= delay_reg - (20'd1000 - counter[19:16]);
        counting <= 1'b1;
        done <= 1'b0;
    end
    else if (~ack) begin
        count <= 4'd0;
        counting <= 1'b0;
        done <= 1'b1;
    end
    else begin
        count <= 4'd0;
        counting <= 1'b0;
        done <= 1'b0;
    end
end

endmodule