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
localparam RESET = 4'b0000;
localparam IDLE = 4'b0001;
localparam SHIFT = 4'b0010;
localparam COUNT = 4'b0011;
localparam DONE = 4'b0100;

reg [3:0] state;
reg [3:0] pattern;
reg [3:0] shift_data;
reg [1:0] shift_count;

// Pattern detector
always @(posedge clk) begin
    if (reset) begin
        pattern <= 4'b0000;
    end else if (state == IDLE) begin
        pattern[3:1] <= pattern[2:0];
        pattern[0] <= data;
    end
end

// Data shifter
always @(posedge clk) begin
    if (reset) begin
        shift_data <= 4'b0000;
        shift_count <= 2'b00;
    end else if (state == SHIFT) begin
        shift_data[3:1] <= shift_data[2:0];
        shift_data[0] <= data;
        shift_count <= shift_count + 1'b1;
    end
end

// Counter controller
always @(posedge clk) begin
    if (reset) begin
        counting <= 1'b0;
    end else if (state == COUNT) begin
        counting <= 1'b1;
    end else begin
        counting <= 1'b0;
    end
end

// Acknowledge controller
always @(posedge clk) begin
    if (reset) begin
        done <= 1'b0;
    end else if (state == DONE) begin
        done <= 1'b1;
    end else begin
        done <= 1'b0;
    end
end

// State machine
always @(posedge clk) begin
    if (reset) begin
        state <= RESET;
        shift_ena <= 1'b0;
    end else begin
        case (state)
            RESET: begin
                state <= IDLE;
                shift_ena <= 1'b0;
            end
            IDLE: begin
                if (pattern == 4'b1101) begin
                    state <= SHIFT;
                    shift_ena <= 1'b1;
                end
            end
            SHIFT: begin
                if (shift_count == 2'b11) begin
                    state <= COUNT;
                    shift_ena <= 1'b0;
                end
            end
            COUNT: begin
                if (done_counting) begin
                    state <= DONE;
                end
            end
            DONE: begin
                if (ack) begin
                    state <= IDLE;
                end
            end
            default: begin
                state <= IDLE;
            end
        endcase
    end
end

endmodule