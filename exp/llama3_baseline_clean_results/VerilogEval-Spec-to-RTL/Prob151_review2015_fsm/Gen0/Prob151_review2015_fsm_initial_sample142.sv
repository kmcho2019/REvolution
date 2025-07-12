module TopModule (
    input clk,
    input reset,
    input data,
    input done_counting,
    input ack,
    output shift_ena,
    output counting,
    output done
);

reg [1:0] state;
reg [3:0] pattern;
reg [1:0] shift_count;

parameter IDLE = 2'b00;
parameter SHIFT = 2'b01;
parameter COUNT = 2'b10;
parameter DONE.State = 2'b11;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= IDLE;
        pattern <= 4'b0000;
        shift_count <= 2'b00;
        shift_ena <= 1'b0;
        counting <= 1'b0;
        done <= 1'b0;
    end else begin
        case (state)
            IDLE: begin
                pattern <= {pattern[2:0], data};
                if (pattern == 4'b1101) begin
                    state <= SHIFT;
                    shift_count <= 2'b00;
                end
                shift_ena <= 1'b0;
                counting <= 1'b0;
                done <= 1'b0;
            end
            SHIFT: begin
                shift_ena <= 1'b1;
                if (shift_count == 2'b11) begin
                    state <= COUNT;
                    counting <= 1'b1;
                end else begin
                    shift_count <= shift_count + 1'b1;
                end
                done <= 1'b0;
            end
            COUNT: begin
                shift_ena <= 1'b0;
                counting <= 1'b1;
                if (done_counting) begin
                    state <= DONE.State;
                    done <= 1'b1;
                end
            end
            DONE.State: begin
                counting <= 1'b0;
                if (ack) begin
                    state <= IDLE;
                    pattern <= 4'b0000;
                    shift_count <= 2'b00;
                    done <= 1'b0;
                end
            end
        endcase
    end
end

endmodule