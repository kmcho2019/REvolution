module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output done
);

reg [1:0] state; // 2 bits for 4 states
reg [7:0] byte1, byte2, byte3; // registers to store the bytes of the message

localparam IDLE = 2'b00;
localparam BYTE1 = 2'b01;
localparam BYTE2 = 2'b10;
localparam BYTE3 = 2'b11;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        done <= 0;
    end else begin
        case (state)
            IDLE: begin
                if (in[3]) begin
                    byte1 <= in;
                    state <= BYTE1;
                end else begin
                    state <= IDLE;
                end
            end
            BYTE1: begin
                byte2 <= in;
                state <= BYTE2;
            end
            BYTE2: begin
                byte3 <= in;
                state <= BYTE3;
            end
            BYTE3: begin
                state <= IDLE;
                done <= 1;
            end
            default: begin
                state <= IDLE;
            end
        endcase
    end
end

always @(posedge clk) begin
    if (~reset && state == BYTE3) begin
        done <= 1;
    end else begin
        done <= 0;
    end
end

endmodule