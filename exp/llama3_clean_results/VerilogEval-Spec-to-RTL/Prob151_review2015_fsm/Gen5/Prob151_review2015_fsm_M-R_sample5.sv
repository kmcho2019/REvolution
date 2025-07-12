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

// Define states
reg [1:0] state;
parameter IDLE = 2'b00;
parameter SHIFT = 2'b01;
parameter COUNT = 2'b10;
parameter WAIT_ACK = 2'b11;

// Define registers
reg [3:0] shift_count;
reg [3:0] duration;
reg [3:0] pattern_count;

// Initialize signals
initial begin
    state = IDLE;
    shift_count = 0;
    duration = 0;
    pattern_count = 0;
    shift_ena = 0;
    counting = 0;
    done = 0;
end

// Pattern detection module
always @(posedge clk) begin
    if (reset) begin
        pattern_count <= 0;
    end
    else begin
        case (pattern_count)
            0: begin
                if (data == 1'b1) begin
                    pattern_count <= pattern_count + 1;
                end
            end
            1: begin
                if (data == 1'b1) begin
                    pattern_count <= pattern_count + 1;
                end
                else begin
                    pattern_count <= 0;
                end
            end
            2: begin
                if (data == 1'b0) begin
                    pattern_count <= pattern_count + 1;
                end
                else begin
                    pattern_count <= 0;
                end
            end
            3: begin
                if (data == 1'b1) begin
                    pattern_count <= 0;
                end
                else begin
                    pattern_count <= 0;
                end
            end
        endcase
    end
end

// State machine
always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        shift_count <= 0;
        duration <= 0;
        shift_ena <= 0;
        counting <= 0;
        done <= 0;
    end
    else begin
        case (state)
            IDLE: begin
                if (pattern_count == 0) begin
                    state <= IDLE;
                end
                else begin
                    state <= SHIFT;
                end
                shift_ena <= 0;
                counting <= 0;
                done <= 0;
            end
            SHIFT: begin
                shift_ena <= 1;
                if (shift_count == 3) begin
                    shift_ena <= 0;
                    shift_count <= 0;
                    state <= COUNT;
                end
                else begin
                    duration[shift_count] <= data;
                    shift_count <= shift_count + 1;
                end
                counting <= 0;
                done <= 0;
            end
            COUNT: begin
                counting <= 1;
                shift_ena <= 0;
                if (done_counting) begin
                    counting <= 0;
                    state <= WAIT_ACK;
                end
                done <= 0;
            end
            WAIT_ACK: begin
                done <= 1;
                if (ack) begin
                    done <= 0;
                    state <= IDLE;
                end
                shift_ena <= 0;
                counting <= 0;
            end
        endcase
    end
end

endmodule