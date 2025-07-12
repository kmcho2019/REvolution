module TopModule(
    input  clk,
    input  reset,
    input  [7:0] in,
    output done
);

reg [1:0] state; // 0: IDLE, 1: BYTE1, 2: BYTE2, 3: DONE
reg [7:0] byte1, byte2;

always @(posedge clk) begin
    if (reset) begin
        state <= 0;
        done <= 0;
    end
    else begin
        case(state)
            0: begin // IDLE
                if (in[3]) begin
                    byte1 <= in;
                    state <= 1;
                end
            end
            1: begin // BYTE1
                byte2 <= in;
                state <= 2;
            end
            2: begin // BYTE2
                state <= 3;
                done <= 1;
            end
            3: begin // DONE
                if (in[3]) begin
                    byte1 <= in;
                    state <= 1;
                end
                else begin
                    state <= 0;
                end
                done <= 0;
            end
        endcase
    end
end

endmodule