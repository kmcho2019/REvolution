module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output done
);

reg [1:0] state; // 2-bit state register
parameter IDLE = 2'b00, BYTE_1 = 2'b01, BYTE_2 = 2'b10;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= IDLE;
        done <= 1'b0;
    end else begin
        case (state)
            IDLE: begin
                if (in[3] == 1'b1) begin
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
                state <= BYTE_1;
                done <= 1'b1;
            end
            default: state <= IDLE;
        endcase
    end
end

endmodule