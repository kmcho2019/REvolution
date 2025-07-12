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
reg [3:0] pattern_reg; // register to store the pattern
reg [3:0] shift_count; // counter for shifting

always @ (posedge clk) begin
    if (reset) begin
        state <= 0; // IDLE
        pattern_reg <= 0;
        shift_count <= 0;
        shift_ena <= 0;
        counting <= 0;
        done <= 0;
    end else begin
        case (state)
            0: begin // IDLE
                if (data) begin // check the pattern
                    pattern_reg <= {pattern_reg[2:0], 1'b1};
                    if (pattern_reg == 4'b1101) begin
                        state <= 1; // SHIFT
                        shift_count <= 0;
                    end else begin
                        pattern_reg <= {pattern_reg[2:0], 1'b1};
                    end
                end else begin
                    pattern_reg <= {pattern_reg[2:0], 1'b0};
                    if (pattern_reg == 4'b1101) begin
                        state <= 1; // SHIFT
                        shift_count <= 0;
                    end else begin
                        pattern_reg <= {pattern_reg[2:0], 1'b0};
                    end
                end
            end
            1: begin // SHIFT
                shift_ena <= 1;
                shift_count <= shift_count + 1;
                if (shift_count == 4) begin
                    state <= 2; // COUNT
                    shift_ena <= 0;
                end
            end
            2: begin // COUNT
                counting <= 1;
                if (done_counting) begin
                    state <= 3; // DONE
                    counting <= 0;
                end
            end
            3: begin // DONE
                done <= 1;
                if (ack) begin
                    state <= 0; // IDLE
                    done <= 0;
                end
            end
        endcase
    end
end

endmodule