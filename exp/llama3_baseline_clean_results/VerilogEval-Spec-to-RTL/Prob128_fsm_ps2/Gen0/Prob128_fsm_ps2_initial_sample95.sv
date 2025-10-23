module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output done
);

reg [1:0] state; // 0: searching, 1: byte1 received, 2: byte2 received
reg [7:0] byte1, byte2, byte3;

always @(posedge clk) begin
    if (reset) begin
        state <= 0;
        done <= 0;
    end else begin
        case (state)
            0: begin // searching for start of message
                if (in[3] == 1) begin
                    byte1 <= in;
                    state <= 1;
                end
            end
            1: begin // byte1 received, waiting for byte2
                byte2 <= in;
                state <= 2;
            end
            2: begin // byte2 received, waiting for byte3
                byte3 <= in;
                state <= 0; // go back to searching
                done <= 1; // signal done
            end
        endcase
    end
end

always @(posedge clk) begin
    if (reset) begin
        done <= 0;
    end else if (state == 0) begin
        done <= 0;
    end
end

endmodule