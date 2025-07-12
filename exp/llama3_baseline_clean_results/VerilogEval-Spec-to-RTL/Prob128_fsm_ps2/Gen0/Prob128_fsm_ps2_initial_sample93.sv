module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

reg [1:0] state; // 0: IDLE, 1: BYTE1, 2: BYTE2, 3: DONE

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // IDLE
        done <= 0;
    end else begin
        case (state)
            0: begin // IDLE
                if (in[3]) begin
                    state <= 1; // BYTE1
                    done <= 0;
                end
            end
            1: begin // BYTE1
                state <= 2; // BYTE2
                done <= 0;
            end
            2: begin // BYTE2
                state <= 3; // DONE
                done <= 0;
            end
            3: begin // DONE
                done <= 1;
                state <= 0; // IDLE
            end
        endcase
    end
end

endmodule