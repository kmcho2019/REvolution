module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg done = 1'b0
);

reg [1:0] state = 2'b00; // 00 - IDLE, 01 - MSG_BYTE_1, 10 - MSG_BYTE_2, 11 - MSG_DONE

always @(posedge clk) begin
    if(reset) begin
        state <= 2'b00;
        done <= 1'b0;
    end else begin
        case(state)
            2'b00: begin // IDLE
                if(in[3]) begin
                    state <= 2'b01;
                end
            end
            2'b01: begin // MSG_BYTE_1
                state <= 2'b10;
            end
            2'b10: begin // MSG_BYTE_2
                state <= 2'b11;
            end
            2'b11: begin // MSG_DONE
                done <= 1'b1;
                if(in[3]) begin
                    state <= 2'b01;
                end else begin
                    state <= 2'b10;
                end
            end
        endcase
        if(state != 2'b11) begin
            done <= 1'b0;
        end
    end
end

endmodule