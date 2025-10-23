module TopModule(
    input clk,
    input reset,
    input data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input ack
);

reg [3:0] state; // 0: IDLE, 1: SHIFT, 2: COUNT, 3: DONE
reg [3:0] delay;
reg [9:0] counter; // counter for 1000 clock cycles
reg [3:0] remaining;
reg [3:0] shift_reg;

always @ (posedge clk) begin
    if (reset) begin
        state <= 0; // IDLE
        done <= 0;
        counting <= 0;
    end else begin
        case (state)
            0: begin // IDLE
                if (shift_reg == 4'b1101) begin
                    state <= 1; // SHIFT
                    shift_reg <= 0;
                end else begin
                    shift_reg <= {shift_reg[2:0], data};
                end
            end
            1: begin // SHIFT
                delay <= {delay[2:0], data};
                if (counter == 4) begin
                    state <= 2; // COUNT
                    counter <= 0;
                    remaining <= delay;
                end else begin
                    counter <= counter + 1;
                end
            end
            2: begin // COUNT
                counting <= 1;
                if (counter == 1000) begin
                    counter <= 0;
                    if (remaining == 0) begin
                        state <= 3; // DONE
                    end else begin
                        remaining <= remaining - 1;
                    end
                end else begin
                    counter <= counter + 1;
                end
                count <= remaining;
            end
            3: begin // DONE
                counting <= 0;
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