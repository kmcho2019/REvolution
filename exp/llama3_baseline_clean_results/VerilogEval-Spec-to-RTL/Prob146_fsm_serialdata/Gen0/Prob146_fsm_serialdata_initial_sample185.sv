module TopModule (
    input clk,
    input in,
    input reset,
    output [7:0] out_byte,
    output done
);

reg [7:0] byte;
reg [2:0] state;
reg [2:0] nextState;
reg done_reg;

always @(posedge clk) begin
    if (reset) begin
        state <= 0;
        done_reg <= 0;
        byte <= 0;
    end else begin
        case (state)
            0: begin // IDLE
                if (!in) begin
                    state <= 1;
                    byte <= 0;
                end else begin
                    state <= 0;
                end
            end
            1: begin // START_BIT
                state <= 2;
            end
            2: begin // DATA_BITS
                byte <= {byte[6:0], in};
                if (byte[7]) begin
                    state <= 3;
                end else begin
                    state <= 2;
                end
            end
            3: begin // STOP_BIT
                if (in) begin
                    state <= 4;
                    done_reg <= 1;
                end else begin
                    state <= 3;
                end
            end
            4: begin // DONE
                done_reg <= 0;
                state <= 0;
            end
        endcase
    end
end

always @(*) begin
    case (state)
        0: begin
            out_byte <= 8'b0;
            done <= 0;
        end
        1: begin
            out_byte <= 8'b0;
            done <= 0;
        end
        2: begin
            out_byte <= 8'b0;
            done <= 0;
        end
        3: begin
            out_byte <= 8'b0;
            done <= 0;
        end
        4: begin
            out_byte <= byte;
            done <= done_reg;
        end
    endcase
end

endmodule