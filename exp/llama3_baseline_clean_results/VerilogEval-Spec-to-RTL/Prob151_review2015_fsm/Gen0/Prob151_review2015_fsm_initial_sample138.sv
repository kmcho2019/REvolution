module TopModule (
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
reg [3:0] pattern; // to detect the start sequence (1101)

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // IDLE
        shift_ena <= 0;
        counting <= 0;
        done <= 0;
        shift_count <= 0;
        pattern <= 0;
    end else begin
        case (state)
            0: begin // IDLE
                if (pattern == 4'b1101) begin // start sequence detected
                    state <= 1; // SHIFT
                    shift_ena <= 1;
                    shift_count <= 0;
                end else begin
                    pattern <= {pattern[2:0], data}; // shift in the new bit
                end
            end
            1: begin // SHIFT
                if (shift_count == 4) begin // 4 bits shifted in
                    state <= 2; // COUNT
                    shift_ena <= 0;
                    counting <= 1;
                end else begin
                    shift_count <= shift_count + 1;
                end
            end
            2: begin // COUNT
                if (done_counting) begin // counters finished counting
                    state <= 3; // DONE
                    counting <= 0;
                    done <= 1;
                end
            end
            3: begin // DONE
                if (ack) begin // acknowledgement received
                    state <= 0; // IDLE
                    done <= 0;
                end
            end
        endcase
    end
end

endmodule