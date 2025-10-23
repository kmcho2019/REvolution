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

reg [3:0] state;
reg [3:0] next_state;
reg [3:0] pattern_detected;
reg [1:0] shift_count;

parameter IDLE = 4'b0000;
parameter SHIFT = 4'b0001;
parameter COUNT = 4'b0010;
parameter DONE = 4'b0011;
parameter RESET = 4'b0100;

always @(*) begin
    case(state)
        IDLE: begin
            if(reset)
                next_state = IDLE;
            else if(pattern_detected == 4'b1101)
                next_state = SHIFT;
            else
                next_state = IDLE;
        end
        SHIFT: begin
            if(shift_count == 4)
                next_state = COUNT;
            else
                next_state = SHIFT;
        end
        COUNT: begin
            if(done_counting)
                next_state = DONE;
            else
                next_state = COUNT;
        end
        DONE: begin
            if(ack)
                next_state = IDLE;
            else
                next_state = DONE;
        end
        default: next_state = IDLE;
    endcase
end

always @(posedge clk) begin
    if(reset)
        state <= IDLE;
    else
        state <= next_state;

    if(reset)
        pattern_detected <= 4'b0000;
    else if(state == IDLE || state == SHIFT) begin
        pattern_detected <= {pattern_detected[2:0], data};
    end

    if(reset)
        shift_count <= 0;
    else if(state == SHIFT) begin
        shift_count <= shift_count + 1;
    end
end

assign shift_ena = (state == SHIFT);
assign counting = (state == COUNT);
assign done = (state == DONE);

endmodule