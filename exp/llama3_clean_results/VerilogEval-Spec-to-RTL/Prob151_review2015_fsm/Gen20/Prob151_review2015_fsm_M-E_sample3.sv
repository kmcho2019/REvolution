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

// Define primary states as one-hot encoded constants
parameter IDLE = 2'b00;
parameter ACTIVE = 2'b01;
parameter DONE_ACK = 2'b10;

reg [1:0] primary_state; // Current primary state of the state machine

// Pattern detection module
module PatternDetect (
    input clk,
    input reset,
    input data,
    output reg detected
);
reg [3:0] pattern; // Pattern register

always @(posedge clk) begin
    if (reset) begin
        pattern <= 0;
        detected <= 0;
    end
    else begin
        pattern <= {pattern[2:0], data};
        if (pattern == 4'b1101) begin
            detected <= 1;
        end
        else begin
            detected <= 0;
        end
    end
end
endmodule

// Shift counter module
module ShiftCounter (
    input clk,
    input reset,
    input enable,
    output reg [1:0] count
);
always @(posedge clk) begin
    if (reset) begin
        count <= 0;
    end
    else if (enable) begin
        count <= count + 1;
    end
end
endmodule

// Instantiate pattern detection and shift counter modules
wire pattern_detected;
PatternDetect pattern_detector(.clk(clk),.reset(reset),.data(data),.detected(pattern_detected));

wire [1:0] shift_count;
reg shift_enable;
ShiftCounter shift_counter(.clk(clk),.reset(reset),.enable(shift_enable),.count(shift_count));

// State machine logic
always @(posedge clk) begin
    if (reset) begin
        primary_state <= IDLE;
        shift_ena <= 0;
        counting <= 0;
        done <= 0;
        shift_enable <= 0;
    end
    else begin
        case (primary_state)
            IDLE: begin
                if (pattern_detected) begin
                    primary_state <= ACTIVE;
                    shift_enable <= 1;
                end
            end
            ACTIVE: begin
                shift_ena <= shift_enable;
                if (shift_count == 2'd4) begin
                    shift_enable <= 0;
                    counting <= 1;
                    primary_state <= DONE_ACK;
                end
            end
            DONE_ACK: begin
                counting <= 0;
                done <= 1;
                if (done_counting && ack) begin
                    primary_state <= IDLE;
                    done <= 0;
                end
            end
            default: ; // Prevent latch inference
        endcase
    end
end

endmodule