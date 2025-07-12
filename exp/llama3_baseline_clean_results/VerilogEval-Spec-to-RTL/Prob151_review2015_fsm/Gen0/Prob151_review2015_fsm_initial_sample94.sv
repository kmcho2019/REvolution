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

    reg [1:0] state; // current state
    reg [1:0] next_state; // next state
    reg [3:0] shift_count; // count of shifts

    // state definitions
    parameter IDLE = 2'b00;
    parameter SHIFT = 2'b01;
    parameter COUNT = 2'b10;
    parameter WAIT_FOR_ACK = 2'b11;

    // internal signals
    reg [3:0] pattern; // input pattern
    reg pattern_match; // pattern match signal

    // sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern <= 4'b0000;
            shift_count <= 4'b0000;
        end else begin
            state <= next_state;
            if (state == IDLE) begin
                pattern <= {pattern[2:0], data};
                if (pattern == 4'b1101) begin
                    pattern <= 4'b0000;
                end
            end else if (state == SHIFT) begin
                shift_count <= shift_count + 1'b1;
            end else if (state == COUNT) begin
                // do nothing
            end else if (state == WAIT_FOR_ACK) begin
                // do nothing
            end
        end
    end

    // combinational logic
    always @(*) begin
        next_state = state;
        shift_ena = 1'b0;
        counting = 1'b0;
        done = 1'b0;

        if (state == IDLE) begin
            if (pattern == 4'b1101) begin
                next_state = SHIFT;
            end
        end else if (state == SHIFT) begin
            shift_ena = 1'b1;
            if (shift_count == 4'b0100) begin
                next_state = COUNT;
            end
        end else if (state == COUNT) begin
            counting = 1'b1;
            if (done_counting) begin
                next_state = WAIT_FOR_ACK;
            end
        end else if (state == WAIT_FOR_ACK) begin
            done = 1'b1;
            if (ack) begin
                next_state = IDLE;
            end
        end
    end
endmodule