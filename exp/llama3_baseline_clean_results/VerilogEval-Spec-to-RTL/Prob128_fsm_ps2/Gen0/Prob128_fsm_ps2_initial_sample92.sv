module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

reg [1:0] state; // 0: IDLE, 1: BYTE_1, 2: BYTE_2, 3: DONE
parameter IDLE = 2'b00, BYTE_1 = 2'b01, BYTE_2 = 2'b10, BYTE_3 = 2'b11;

always @(posedge clk) begin
    if(reset) begin
        state <= IDLE;
        done <= 1'b0;
    end else begin
        case(state)
            IDLE: begin
                if(in[3]) begin
                    state <= BYTE_1;
                end else begin
                    state <= IDLE;
                end
                done <= 1'b0;
            end
            BYTE_1: begin
                state <= BYTE_2;
                done <= 1'b0;
            end
            BYTE_2: begin
                state <= BYTE_3;
                done <= 1'b0;
            end
            BYTE_3: begin
                state <= IDLE;
                done <= 1'b1;
            end
            default: begin
                state <= IDLE;
                done <= 1'b0;
            end
        endcase
    end
end

endmodule