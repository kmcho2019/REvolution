module TopModule(
    input  clk,
    input  reset,
    input  data,
    input  done_counting,
    input  ack,
    output reg shift_ena,
    output reg counting,
    output reg done
);

// Define the states
localparam IDLE = 2'b00;
localparam SHIFT_COUNT = 2'b01;
localparam DONE_ACK = 2'b10;

reg [1:0] state;
reg [3:0] pattern;
reg [1:0] shift_count;

// Pattern detection and state machine
always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        pattern <= 4'b0000;
        shift_count <= 2'b00;
    end else begin
        case (state)
            IDLE: begin
                pattern[3:1] <= pattern[2:0];
                pattern[0] <= data;
                if (pattern == 4'b1101) begin
                    state <= SHIFT_COUNT;
                end
            end
            SHIFT_COUNT: begin
                if (shift_count == 4) begin
                    state <= DONE_ACK;
                    shift_count <= 0;
                end else if (done_counting) begin
                    state <= DONE_ACK;
                    shift_count <= 0;
                end else begin
                    shift_count <= shift_count + 1;
                end
            end
            DONE_ACK: begin
                if (ack) begin
                    state <= IDLE;
                end
            end
        endcase
    end
end

// Output assignments
always @(posedge clk) begin
    if (state == IDLE) begin
        shift_ena <= 0;
        counting <= 0;
        done <= 0;
    end else if (state == SHIFT_COUNT) begin
        shift_ena <= 1;
        counting <= 0;
        done <= 0;
    end else if (state == DONE_ACK) begin
        shift_ena <= 0;
        counting <= 1;
        done <= 1;
    end
end

endmodule