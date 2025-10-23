module TopModule (
    input clk,
    input reset,
    input data,
    input done_counting,
    input ack,
    output reg shift_ena,
    output reg counting,
    output reg done
);

// Define pipeline stages
reg pattern_detected;
reg shifting_complete;
reg counting_complete;
reg ack_received;

// Define shift register
reg [3:0] shift_reg;
reg [3:0] duration;

// Define counters
reg [1:0] shift_count;
reg [1:0] ack_count;

// Initialize signals
initial begin
    pattern_detected = 0;
    shifting_complete = 0;
    counting_complete = 0;
    ack_received = 0;
    shift_ena = 0;
    counting = 0;
    done = 0;
    shift_reg = 0;
    duration = 0;
    shift_count = 0;
    ack_count = 0;
end

// Pattern detection stage
always @(posedge clk) begin
    if (reset) begin
        pattern_detected <= 0;
    end
    else begin
        reg [3:0] pattern_reg;
        pattern_reg <= {pattern_reg[2:0], data};
        if (pattern_reg == 4'b1101) begin
            pattern_detected <= 1;
        end
        else begin
            pattern_detected <= 0;
        end
    end
end

// Shifting stage
always @(posedge clk) begin
    if (reset) begin
        shifting_complete <= 0;
        shift_count <= 0;
        shift_reg <= 0;
    end
    else begin
        if (pattern_detected) begin
            shift_ena <= 1;
            shift_reg <= {shift_reg[2:0], data};
            shift_count <= shift_count + 1;
            if (shift_count == 4) begin
                shifting_complete <= 1;
                duration <= shift_reg;
            end
            else begin
                shifting_complete <= 0;
            end
        end
        else begin
            shift_ena <= 0;
            shifting_complete <= 0;
        end
    end
end

// Counting stage
always @(posedge clk) begin
    if (reset) begin
        counting_complete <= 0;
        counting <= 0;
    end
    else begin
        if (shifting_complete) begin
            counting <= 1;
            if (done_counting) begin
                counting_complete <= 1;
            end
            else begin
                counting_complete <= 0;
            end
        end
        else begin
            counting <= 0;
            counting_complete <= 0;
        end
    end
end

// Done and ACK stage
always @(posedge clk) begin
    if (reset) begin
        ack_received <= 0;
        done <= 0;
    end
    else begin
        if (counting_complete) begin
            done <= 1;
            if (ack) begin
                ack_received <= 1;
            end
            else begin
                ack_received <= 0;
            end
        end
        else begin
            done <= 0;
            ack_received <= 0;
        end
    end
end

// Reset state machine
always @(posedge clk) begin
    if (reset || ack_received) begin
        pattern_detected <= 0;
        shifting_complete <= 0;
        counting_complete <= 0;
        ack_received <= 0;
        shift_ena <= 0;
        counting <= 0;
        done <= 0;
    end
end

endmodule