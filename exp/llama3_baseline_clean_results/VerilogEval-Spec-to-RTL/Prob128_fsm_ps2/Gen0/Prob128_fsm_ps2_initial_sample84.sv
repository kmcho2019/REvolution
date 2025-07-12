module TopModule(
    input  clk,
    input  reset,
    input  [7:0] in,
    output done
);

reg [1:0] state; // 2 bits for 4 states
reg done_reg;

always @(posedge clk) begin
    if (reset) begin // active high synchronous reset
        state <= 0; // IDLE state
        done_reg <= 0;
    end else begin
        case (state)
            0: begin // IDLE state
                if (in[3]) begin
                    state <= 1; // transition to BYTE1 state
                end
            end
            1: begin // BYTE1 state
                state <= 2; // transition to BYTE2 state
            end
            2: begin // BYTE2 state
                state <= 3; // transition to DONE state
            end
            3: begin // DONE state
                state <= 0; // transition back to IDLE state
                done_reg <= 1; // signal done
            end
            default: state <= 0; // default to IDLE state
        endcase
    end
end

always @(posedge clk) begin
    if (reset) begin
        done_reg <= 0;
    end else if (state == 3) begin // DONE state
        done_reg <= 1;
    end else begin
        done_reg <= 0;
    end
end

assign done = done_reg;

endmodule