module TopModule(
    input clk,
    input reset,
    input data,
    input done_counting,
    input ack,
    output reg shift_ena,
    output reg counting,
    output reg done
);

reg [3:0] state;
reg [3:0] next_state;
reg [1:0] count;

// Define the states
parameter IDLE = 4'b0000, SHIFT = 4'b0001, COUNT = 4'b0010, DONE = 4'b0011;

always @(*) begin
    case(state)
        IDLE: begin
            if (data == 1'b1 && count == 2'b11) begin
                next_state = SHIFT;
                count = 2'b00;
            end else if (data == 1'b1 && count == 2'b10) begin
                next_state = IDLE;
                count = 2'b11;
            end else if (data == 1'b1 && count == 2'b01) begin
                next_state = IDLE;
                count = 2'b10;
            end else if (data == 1'b1 && count == 2'b00) begin
                next_state = IDLE;
                count = 2'b01;
            end else if (data == 1'b0 && count == 2'b11) begin
                next_state = IDLE;
                count = 2'b00;
            end else if (data == 1'b0 && count == 2'b10) begin
                next_state = IDLE;
                count = 2'b00;
            end else if (data == 1'b0 && count == 2'b01) begin
                next_state = IDLE;
                count = 2'b00;
            end else if (data == 1'b0 && count == 2'b00) begin
                next_state = IDLE;
                count = 2'b00;
            end
        end
        SHIFT: begin
            next_state = SHIFT;
            if (count == 2'b11) begin
                next_state = COUNT;
                count = 2'b00;
            end
            count = count + 1'b1;
        end
        COUNT: begin
            next_state = COUNT;
            if (done_counting == 1'b1) begin
                next_state = DONE;
            end
        end
        DONE: begin
            next_state = DONE;
            if (ack == 1'b1) begin
                next_state = IDLE;
            end
        end
    endcase
end

always @(posedge clk) begin
    if (reset == 1'b1) begin
        state = IDLE;
        shift_ena = 1'b0;
        counting = 1'b0;
        done = 1'b0;
    end else begin
        state = next_state;
        case(state)
            IDLE: begin
                shift_ena = 1'b0;
                counting = 1'b0;
                done = 1'b0;
            end
            SHIFT: begin
                shift_ena = 1'b1;
                counting = 1'b0;
                done = 1'b0;
            end
            COUNT: begin
                shift_ena = 1'b0;
                counting = 1'b1;
                done = 1'b0;
            end
            DONE: begin
                shift_ena = 1'b0;
                counting = 1'b0;
                done = 1'b1;
            end
        endcase
    end
end

endmodule