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

enum logic [2:0] {IDLE, DETECT, SHIFT, COUNT, DONE} state;

reg [3:0] pattern;
reg [1:0] shift_count;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        pattern <= 4'b0000;
        shift_count <= 2'b00;
    end else begin
        pattern <= {pattern[2:0], data};
        
        case (state)
            IDLE: begin
                if (pattern == 4'b1101) begin
                    state <= DETECT;
                end
            end
            DETECT: begin
                state <= SHIFT;
            end
            SHIFT: begin
                shift_count <= shift_count + 1'b1;
                if (shift_count == 2'b11) begin
                    state <= COUNT;
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
        endcase
    end
end

assign shift_ena = (state == DETECT) || (state == SHIFT && shift_count < 2'b11);
assign counting = (state == COUNT);
assign done = (state == DONE);

endmodule