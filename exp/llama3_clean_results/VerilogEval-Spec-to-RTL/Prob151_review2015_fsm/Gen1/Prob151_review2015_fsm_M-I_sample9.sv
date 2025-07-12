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

enum logic [2:0] {
    IDLE = 3'b000,
    SHIFT = 3'b001,
    COUNT = 3'b010,
    DONE = 3'b011,
    ACK = 3'b100
} state, next_state;

reg [3:0] sequence;
reg [1:0] shift_count;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        sequence <= 0;
        shift_count <= 0;
    end else begin
        case (state)
            IDLE: begin
                if (data) begin
                    sequence <= {sequence[2:0], 1'b1};
                end else begin
                    sequence <= {sequence[2:0], 1'b0};
                end
                if (sequence == 4'b1101) begin
                    state <= SHIFT;
                    sequence <= 0;
                    shift_count <= 0;
                end
            end
            SHIFT: begin
                shift_ena <= 1;
                if (data) begin
                    sequence <= {sequence[2:0], 1'b1};
                end else begin
                    sequence <= {sequence[2:0], 1'b0};
                end
                shift_count <= shift_count + 1;
                if (shift_count == 4) begin
                    state <= COUNT;
                end
            end
            COUNT: begin
                counting <= 1;
                if (done_counting) begin
                    state <= DONE;
                end
            end
            DONE: begin
                done <= 1;
                if (ack) begin
                    state <= IDLE;
                end
            end
        endcase
    end
end

assign shift_ena = (state == SHIFT)? 1'b1 : 1'b0;
assign counting = (state == COUNT)? 1'b1 : 1'b0;
assign done = (state == DONE)? 1'b1 : 1'b0;

endmodule