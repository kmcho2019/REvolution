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

reg [1:0] state;
reg [3:0] shift_reg;

always @ (posedge clk) begin
    if (reset) begin
        state <= 0;
        shift_ena <= 0;
        counting <= 0;
        done <= 0;
        shift_reg <= 0;
    end
    else begin
        case (state)
            0: begin // IDLE
                if (shift_reg == 4'b1101) begin
                    state <= 1;
                    shift_reg <= 0;
                    shift_ena <= 1;
                end
                else begin
                    shift_reg <= {shift_reg[2:0], data};
                end
            end
            1: begin // SHIFT
                if (shift_reg == 4'b1111) begin
                    state <= 2;
                    shift_ena <= 0;
                    counting <= 1;
                end
                else begin
                    shift_reg <= shift_reg + 1;
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
            default: state <= 0;
        endcase
    end
end

endmodule