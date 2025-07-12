module TopModule (
    input  clk,
    input  reset,
    input  data,
    input  done_counting,
    input  ack,
    output shift_ena,
    output counting,
    output done
);

reg [1:0] state; // 0: IDLE, 1: SHIFT, 2: COUNT, 3: DONE
reg [3:0] pattern; // shift register for input pattern
reg [1:0] shift_count; // counter for shifts

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 0; // IDLE
        pattern <= 0;
        shift_count <= 0;
        shift_ena <= 0;
        counting <= 0;
        done <= 0;
    end else begin
        case (state)
            0: begin // IDLE
                if (pattern == 4'b1101) begin
                    state <= 1; // SHIFT
                    pattern <= 0;
                    shift_count <= 0;
                    shift_ena <= 1;
                end else begin
                    pattern <= {pattern[2:0], data};
                end
            end
            1: begin // SHIFT
                pattern <= {pattern[2:0], data};
                shift_count <= shift_count + 1;
                if (shift_count == 4) begin
                    state <= 2; // COUNT
                    shift_ena <= 0;
                    counting <= 1;
                end
            end
            2: begin // COUNT
                if (done_counting) begin
                    state <= 3; // DONE
                    counting <= 0;
                    done <= 1;
                end
            end
            3: begin // DONE
                if (ack) begin
                    state <= 0; // IDLE
                    done <= 0;
                end
            end
        endcase
    end
end

endmodule