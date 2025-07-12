module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output done
);

reg [1:0] state; // 0: searching, 1: byte1_received, 2: byte2_received
reg [7:0] byte1, byte2, byte3;

always @(posedge clk) begin
    if (reset) begin
        state <= 0;
        done <= 0;
    end else begin
        case (state)
            0: begin // searching
                if (in[3]) begin // potential byte 1
                    byte1 <= in;
                    state <= 1;
                end
            end
            1: begin // byte1 received
                byte2 <= in;
                state <= 2;
            end
            2: begin // byte2 received
                byte3 <= in;
                state <= 0; // go back to searching
                done <= 1; // signal done
            end
            default: begin
                state <= 0; // handle invalid states
            end
        endcase
    end
end

always @(posedge clk) begin
    if (~reset) begin
        if (state == 0 && in[3]) begin
            // no action needed, handled in always block
        end
    end
end

endmodule