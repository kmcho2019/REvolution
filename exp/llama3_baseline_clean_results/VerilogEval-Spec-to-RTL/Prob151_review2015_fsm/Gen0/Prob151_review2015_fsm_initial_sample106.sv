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

reg [1:0] state; // 0: IDLE, 1: SHIFT, 2: COUNT, 3: DONE
reg [3:0] shift_count;
reg [3:0] pattern;

always @(posedge clk) begin
    if (reset) begin
        state <= 0;
        shift_ena <= 0;
        counting <= 0;
        done <= 0;
        shift_count <= 0;
        pattern <= 0;
    end else begin
        case (state)
            0: begin // IDLE
                if (pattern == 4'b1101) begin
                    state <= 1;
                    shift_ena <= 1;
                    shift_count <= 1;
                    pattern <= 0;
                end else begin
                    pattern <= {pattern[2:0], data};
                end
            end
            1: begin // SHIFT
                if (shift_count == 4) begin
                    state <= 2;
                    shift_ena <= 0;
                    counting <= 1;
                end else begin
                    shift_count <= shift_count + 1;
                end
            end
            2: begin // COUNT
                if (done_counting) begin
                    state <= 3;
                    counting <= 0;
                    done <= 1;
                end
            end
            3: begin // DONE
                if (ack) begin
                    state <= 0;
                    done <= 0;
                end
            end
        endcase
    end
end

endmodule