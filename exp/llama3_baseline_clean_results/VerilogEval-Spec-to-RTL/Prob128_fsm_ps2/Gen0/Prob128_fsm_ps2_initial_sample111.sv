module TopModule(
    input           clk,
    input           reset,
    input  [7:0]     in,
    output          done
);

reg [1:0] state; // 2 bits for 4 states: IDLE, BYTE1, BYTE2, BYTE3
localparam IDLE = 2'b00, BYTE1 = 2'b01, BYTE2 = 2'b10, BYTE3 = 2'b11;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        done <= 0;
    end else begin
        case (state)
            IDLE: begin
                if (in[3]) begin
                    state <= BYTE1;
                end else begin
                    state <= IDLE;
                end
                done <= 0;
            end
            BYTE1: begin
                state <= BYTE2;
                done <= 0;
            end
            BYTE2: begin
                state <= BYTE3;
                done <= 0;
            end
            BYTE3: begin
                state <= IDLE;
                done <= 1;
            end
        endcase
    end
end

endmodule