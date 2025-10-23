module TopModule(
    input  clk,
    input  reset,
    input  [7:0] in,
    output [23:0] out_bytes,
    output done
);

reg [1:0] state; // 0: IDLE, 1: BYTE1, 2: BYTE2, 3: DONE
reg [23:0] message; // store the received message
reg [7:0] byte1, byte2, byte3; // store the received bytes

always @(posedge clk) begin
    if (reset) begin // reset the FSM and datapath
        state <= 0;
        message <= 24'h0;
        byte1 <= 8'h0;
        byte2 <= 8'h0;
        byte3 <= 8'h0;
    end else begin
        case (state)
            0: begin // IDLE
                if (in[3] == 1'b1) begin // found the first byte of a message
                    byte1 <= in;
                    state <= 1;
                end
            end
            1: begin // BYTE1
                byte2 <= in;
                state <= 2;
            end
            2: begin // BYTE2
                byte3 <= in;
                state <= 3;
            end
            3: begin // DONE
                message <= {byte1, byte2, byte3};
                state <= 0;
            end
        endcase
    end
end

always @(posedge clk) begin
    if (reset) begin // reset the done signal
        done <= 1'b0;
    end else begin
        case (state)
            3: begin // DONE
                done <= 1'b1;
            end
            default: begin
                done <= 1'b0;
            end
        endcase
    end
end

assign out_bytes = (done)? message : 24'hxxxxxx; // output the message when done is asserted

endmodule