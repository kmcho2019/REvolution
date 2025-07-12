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
reg [3:0] pattern;
reg [3:0] duration;

// Initialize signals
initial begin
    state = IDLE;
    shift_count = 0;
    pattern = 0;
    duration = 0;
    shift_ena = 0;
    counting = 0;
    done = 0;
end

// Sequential logic
always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        shift_count <= 0;
        pattern <= 0;
        duration <= 0;
    end
    else begin
        case (state)
            IDLE: begin
                if (pattern == 4'b1101) begin
                    pattern <= 0;
                    state <= SHIFT;
                end
                else begin
                    pattern <= {pattern[2:0], data};
                end
            end
            SHIFT: begin
                if (shift_count == 4) begin
                    state <= COUNT;
                end
                else begin
                    duration <= {duration[2:0], data};
                    shift_count <= shift_count + 1;
                end
            end
            COUNT: begin
                if (done_counting) begin
                    state <= WAIT_ACK;
                end
            end
            WAIT_ACK: begin
                if (ack) begin
                    state <= IDLE;
                end
            end
        endcase
    end
end

// Combinational logic
assign shift_ena = (state == SHIFT);
assign counting = (state == COUNT);
assign done = (state == WAIT_ACK);

endmodule