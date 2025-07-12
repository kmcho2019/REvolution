module TopModule(
    input  clk,
    input  reset,
    output reg shift_ena
);

reg [1:0] state; // 0: idle, 1: reset_start, 2: shift_enable, 3: done
reg [1:0] counter;

always @(posedge clk) begin
    if (reset) begin
        state <= 1; // reset_start
        shift_ena <= 1;
        counter <= 0;
    end else begin
        case(state)
            1: begin // reset_start
                state <= 2; // shift_enable
            end
            2: begin // shift_enable
                if (counter < 3) begin
                    counter <= counter + 1;
                end else begin
                    state <= 3; // done
                    shift_ena <= 0;
                end
            end
            3: begin // done
                // stay in this state until next reset
            end
            default: begin
                // handle default case
                state <= 1;
                shift_ena <= 0;
                counter <= 0;
            end
        endcase
    end
end

always @(posedge clk) begin
    if (state == 2) begin
        shift_ena <= 1;
    end else if (state != 2) begin
        shift_ena <= 0;
    end
end

endmodule