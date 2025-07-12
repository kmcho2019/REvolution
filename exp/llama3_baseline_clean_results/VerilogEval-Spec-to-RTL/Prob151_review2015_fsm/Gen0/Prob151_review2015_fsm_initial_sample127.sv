module TopModule (
    input  clk,
    input  reset,
    input  data,
    input  done_counting,
    input  ack,
    output reg shift_ena,
    output reg counting,
    output reg done
);

reg [3:0] state; // 4 states: IDLE, SHIFT, COUNT, DONE
reg [2:0] shift_count; // Counter for shifting bits
reg [3:0] pattern; // Register to store the incoming pattern

parameter IDLE = 4'd0;
parameter SHIFT = 4'd1;
parameter COUNT = 4'd2;
parameter DONE_WAIT = 4'd3;

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
                // Store the incoming pattern
                pattern <= {pattern[2:0], data};
                if (pattern == 4'b1101) begin
                    state <= SHIFT;
                end
            end
            SHIFT: begin
                shift_ena <= 1;
                shift_count <= shift_count + 1;
                if (shift_count == 4) begin
                    state <= COUNT;
                    shift_ena <= 0;
                end
            end
            COUNT: begin
                counting <= 1;
                if (done_counting) begin
                    state <= DONE_WAIT;
                    counting <= 0;
                end
            end
            DONE_WAIT: begin
                done <= 1;
                if (ack) begin
                    state <= IDLE;
                    done <= 0;
                end
            end
        endcase
    end
end

endmodule