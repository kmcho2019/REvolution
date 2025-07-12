module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output done
);

enum logic [1:0] {IDLE, BYTE1, BYTE2, BYTE3} state, nextState;

always_ff @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        done <= 1'b0;
    end else begin
        state <= nextState;
        case (state)
            IDLE: begin
                if (in[3] == 1'b1) begin
                    nextState <= BYTE1;
                end else begin
                    nextState <= IDLE;
                end
            end
            BYTE1: nextState <= BYTE2;
            BYTE2: nextState <= BYTE3;
            BYTE3: begin
                nextState <= IDLE;
                done <= 1'b1;
            end
        endcase
    end
end

always_comb begin
    case (state)
        IDLE: begin
            done = 1'b0;
        end
        BYTE1: begin
            done = 1'b0;
        end
        BYTE2: begin
            done = 1'b0;
        end
        BYTE3: begin
            done = 1'b0; // done is handled in the FF
        end
    endcase
end

endmodule