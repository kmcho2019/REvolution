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
reg [2:0] shift_count;
reg [3:0] pattern;

parameter IDLE = 4'b0000;
parameter SHIFT = 4'b0001;
parameter COUNTING = 4'b0010;
parameter DONE = 4'b0011;
parameter ACK = 4'b0100;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        shift_ena <= 0;
        counting <= 0;
        done <= 0;
        shift_count <= 0;
        pattern <= 0;
    end else begin
        case (state)
            IDLE: begin
                if (data == 1'b1) begin
                    pattern <= {pattern[2:0], 1'b1};
                    if (pattern == 4'b1101) begin
                        state <= SHIFT;
                    end
                end else begin
                    pattern <= {pattern[2:0], 1'b0};
                end
            end
            SHIFT: begin
                shift_ena <= 1;
                shift_count <= shift_count + 1;
                if (shift_count == 3) begin
                    shift_ena <= 0;
                    state <= COUNTING;
                    shift_count <= 0;
                end
            end
            COUNTING: begin
                counting <= 1;
                if (done_counting) begin
                    state <= DONE;
                    counting <= 0;
                end
            end
            DONE: begin
                done <= 1;
                if (ack) begin
                    state <= ACK;
                end
            end
            ACK: begin
                if (ack) begin
                    state <= IDLE;
                    done <= 0;
                end
            end
        endcase
    end
end

endmodule