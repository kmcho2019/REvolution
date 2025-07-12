module TopModule(
    input  clk,
    input  reset,
    input  data,
    input  done_counting,
    input  ack,
    output shift_ena,
    output counting,
    output done
);

reg [1:0] shift_count;
reg [3:0] pattern;
reg [3:0] state;

parameter IDLE = 4'b0000;
parameter SHIFT = 4'b0001;
parameter COUNT = 4'b0010;
parameter DONE = 4'b0011;
parameter ACK = 4'b0100;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        shift_ena <= 0;
        counting <= 0;
        done <= 0;
    end else begin
        case (state)
            IDLE: begin
                if (pattern == 4'b1101) begin
                    state <= SHIFT;
                    shift_count <= 4'b0000;
                    shift_ena <= 1;
                end else if (data == 1'b1) begin
                    pattern <= {pattern[2:0], 1'b1};
                end else begin
                    pattern <= {pattern[2:0], 1'b0};
                end
            end
            SHIFT: begin
                shift_count <= shift_count + 1;
                if (shift_count == 4) begin
                    state <= COUNT;
                    shift_ena <= 0;
                    counting <= 1;
                end
            end
            COUNT: begin
                if (done_counting) begin
                    state <= DONE;
                    counting <= 0;
                    done <= 1;
                end
            end
            DONE: begin
                if (ack) begin
                    state <= ACK;
                    done <= 0;
                end
            end
            ACK: begin
                state <= IDLE;
            end
        endcase
    end
end

endmodule