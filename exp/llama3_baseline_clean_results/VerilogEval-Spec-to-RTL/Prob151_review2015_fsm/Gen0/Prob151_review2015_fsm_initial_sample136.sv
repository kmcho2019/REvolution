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

    reg [1:0] state;
    reg [3:0] shift_count;

    // States
    parameter IDLE    = 2'b00;
    parameter SHIFT   = 2'b01;
    parameter COUNT   = 2'b10;
    parameter DONE    = 2'b11;

    // Signals
    reg [3:0] seq;
    reg seq_detected;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_ena <= 0;
            counting <= 0;
            done <= 0;
            shift_count <= 0;
            seq <= 0;
            seq_detected <= 0;
        end
        else begin
            case (state)
                IDLE: begin
                    // Check for sequence 1101
                    seq <= {seq[2:0], data};
                    if ({seq[3:0]} == 4'b1101) begin
                        seq_detected <= 1;
                    end
                    else begin
                        seq_detected <= 0;
                    end

                    if (seq_detected) begin
                        state <= SHIFT;
                    end
                end

                SHIFT: begin
                    shift_ena <= 1;
                    shift_count <= shift_count + 1;
                    if (shift_count == 4) begin
                        shift_ena <= 0;
                        state <= COUNT;
                        shift_count <= 0;
                    end
                end

                COUNT: begin
                    counting <= 1;
                    if (done_counting) begin
                        counting <= 0;
                        state <= DONE;
                    end
                end

                DONE: begin
                    done <= 1;
                    if (ack) begin
                        done <= 0;
                        state <= IDLE;
                    end
                end
            endcase
        end
    end
endmodule