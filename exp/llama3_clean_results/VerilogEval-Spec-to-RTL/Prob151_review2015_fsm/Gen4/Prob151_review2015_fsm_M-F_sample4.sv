module TopModule(
    input clk,
    input reset,
    input data,
    input done_counting,
    input ack,
    output reg shift_ena,
    output reg counting,
    output reg done
);

reg [3:0] shift_reg;
reg [2:0] state;
reg [3:0] counter;

always @(posedge clk) begin
    if (reset) begin
        state <= 0;
        counter <= 0;
        shift_reg <= 0;
        shift_ena <= 0;
        counting <= 0;
        done <= 0;
    end else begin
        case (state)
            0: begin // IDLE
                shift_reg <= {shift_reg[2:0], data};
                shift_ena <= 0;
                counting <= 0;
                done <= 0;
                if (shift_reg == 4'b1101) begin
                    state <= 1;
                    counter <= 0;
                end
            end
            1: begin // SHIFT
                shift_ena <= 1;
                counter <= counter + 1;
                counting <= 0;
                done <= 0;
                if (counter == 4) begin
                    state <= 2;
                end
            end
            2: begin // COUNT
                shift_ena <= 0;
                counting <= 1;
                done <= 0;
                if (done_counting) begin
                    state <= 3;
                end
            end
            3: begin // DONE
                shift_ena <= 0;
                counting <= 0;
                done <= 1;
                if (ack) begin
                    state <= 0;
                end
            end
        endcase
    end
end

endmodule