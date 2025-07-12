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

reg [1:0] state; // 4 states: IDLE, SHIFT, COUNT, DONE
reg [1:0] next_state;
reg [3:0] shift_count;
reg [3:0] sequence;
reg seq_found;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 2'b00; // IDLE
        shift_ena <= 1'b0;
        counting <= 1'b0;
        done <= 1'b0;
        shift_count <= 4'b0000;
        sequence <= 4'b0000;
        seq_found <= 1'b0;
    end else begin
        case(state)
            2'b00: begin // IDLE
                if (sequence == 4'b1101) begin
                    state <= 2'b01; // SHIFT
                    sequence <= 4'b0000;
                    shift_count <= 4'b0001;
                    shift_ena <= 1'b1;
                    counting <= 1'b0;
                    done <= 1'b0;
                end else if (data == 1'b1) begin
                    sequence <= {sequence[2:0], 1'b1};
                end else begin
                    sequence <= {sequence[2:0], 1'b0};
                end
            end
            2'b01: begin // SHIFT
                if (shift_count == 4'b1000) begin
                    state <= 2'b10; // COUNT
                    shift_ena <= 1'b0;
                    counting <= 1'b1;
                end else begin
                    shift_count <= shift_count + 1'b1;
                    if (data == 1'b1) begin
                        sequence <= {sequence[2:0], 1'b1};
                    end else begin
                        sequence <= {sequence[2:0], 1'b0};
                    end
                end
            end
            2'b10: begin // COUNT
                if (done_counting == 1'b1) begin
                    state <= 2'b11; // DONE
                    counting <= 1'b0;
                    done <= 1'b1;
                end
            end
            2'b11: begin // DONE
                if (ack == 1'b1) begin
                    state <= 2'b00; // IDLE
                    done <= 1'b0;
                end
            end
        endcase
    end
end

endmodule