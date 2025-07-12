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

reg [1:0] state;
reg [3:0] pattern_reg;
reg [1:0] shift_cnt;

always @(posedge clk) begin
    if (reset) begin
        state <= 0;
        pattern_reg <= 0;
        shift_cnt <= 0;
        shift_ena <= 0;
        counting <= 0;
        done <= 0;
    end
    else begin
        pattern_reg <= {pattern_reg[2:0], data};
        
        case (state)
            0: begin // IDLE
                if (pattern_reg == 4'b1101) begin
                    state <= 1;
                    shift_cnt <= 1;
                    shift_ena <= 1;
                end
            end
            1: begin // SHIFT
                if (shift_cnt == 4) begin
                    state <= 2;
                    shift_ena <= 0;
                    counting <= 1;
                end
                else begin
                    shift_cnt <= shift_cnt + 1;
                end
            end
            2: begin // COUNT
                if (done_counting) begin
                    state <= 3;
                    counting <= 0;
                    done <= 1;
                end
            end
            3: begin // WAIT_ACK
                if (ack) begin
                    state <= 0;
                    done <= 0;
                end
            end
        endcase
    end
end

endmodule