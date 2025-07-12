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

reg [2:0] state; // 0: IDLE, 1: SHIFT, 2: COUNT, 3: DONE, 4: ACK
reg [3:0] sequence;
reg [1:0] shift_count;

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // IDLE
        sequence <= 0;
        shift_count <= 0;
        shift_ena <= 0;
        counting <= 0;
        done <= 0;
    end else begin
        case (state)
            0: begin // IDLE
                if (data) begin
                    sequence <= {sequence[2:0], 1'b1};
                end else begin
                    sequence <= {sequence[2:0], 1'b0};
                end
                if (sequence == 4'b1101) begin
                    state <= 1; // SHIFT
                    sequence <= 0;
                    shift_count <= 0;
                end
                shift_ena <= 0;
                counting <= 0;
                done <= 0;
            end
            1: begin // SHIFT
                shift_ena <= 1;
                if (data) begin
                    sequence <= {sequence[2:0], 1'b1};
                end else begin
                    sequence <= {sequence[2:0], 1'b0};
                end
                shift_count <= shift_count + 1;
                if (shift_count == 4) begin
                    state <= 2; // COUNT
                    shift_ena <= 0;
                end
                counting <= 0;
                done <= 0;
            end
            2: begin // COUNT
                counting <= 1;
                shift_ena <= 0;
                if (done_counting) begin
                    state <= 3; // DONE
                end
                done <= 0;
            end
            3: begin // DONE
                done <= 1;
                counting <= 0;
                shift_ena <= 0;
                if (ack) begin
                    state <= 0; // IDLE
                end
            end
            default: begin // Default State
                shift_ena <= 0;
                counting <= 0;
                done <= 0;
            end
        endcase
    end
end

endmodule