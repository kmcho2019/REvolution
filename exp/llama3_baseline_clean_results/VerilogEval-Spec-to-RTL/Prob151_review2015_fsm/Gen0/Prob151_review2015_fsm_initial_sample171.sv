module TopModule(
    input clk,
    input reset,
    input data,
    input done_counting,
    input ack,
    output shift_ena,
    output counting,
    output done
);

// Define states
parameter IDLE = 2'b00;
parameter SHIFT = 2'b01;
parameter COUNT = 2'b10;
parameter DONE_STATE = 2'b11;

// State register
reg [1:0] state;
reg [1:0] next_state;

// Counter for shifting
reg [1:0] shift_count;

// Pattern detection
reg [3:0] pattern;

// Output signals
assign shift_ena = (state == SHIFT);
assign counting = (state == COUNT);
assign done = (state == DONE_STATE);

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        shift_count <= 0;
        pattern <= 0;
    end else begin
        case (state)
            IDLE: begin
                // Shift pattern
                pattern <= {data, pattern[3:1]};
                if (pattern == 4'b1101) begin
                    state <= SHIFT;
                end else begin
                    state <= IDLE;
                end
            end
            SHIFT: begin
                shift_count <= shift_count + 1;
                if (shift_count == 4) begin
                    state <= COUNT;
                    shift_count <= 0;
                end else begin
                    state <= SHIFT;
                end
            end
            COUNT: begin
                if (done_counting) begin
                    state <= DONE_STATE;
                end else begin
                    state <= COUNT;
                end
            end
            DONE_STATE: begin
                if (ack) begin
                    state <= IDLE;
                end else begin
                    state <= DONE_STATE;
                end
            end
        endcase
    end
end

endmodule