module TopModule(
    input  clk,
    input  reset,
    input  data,
    input  done_counting,
    input  ack,
    output reg shift_ena,
    output reg counting,
    output reg done
);

reg [1:0] state; // 0: IDLE, 1: SHIFT, 2: COUNT, 3: DONE
reg [3:0] counter; // Counter for shifting bits
reg [3:0] shift_count; // Counter for number of bits shifted
reg [3:0] sequence; // Register to store the received sequence

always @ (posedge clk) begin
    if (reset) begin
        state <= 0; // IDLE
        counter <= 0;
        shift_count <= 0;
        sequence <= 0;
        shift_ena <= 0;
        counting <= 0;
        done <= 0;
    end else begin
        case (state)
            0: begin // IDLE
                sequence <= {sequence[2:0], data};
                if (sequence == 4'b1101) begin
                    state <= 1; // SHIFT
                    shift_count <= 0;
                end
            end
            1: begin // SHIFT
                shift_ena <= 1;
                sequence <= {sequence[2:0], data};
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