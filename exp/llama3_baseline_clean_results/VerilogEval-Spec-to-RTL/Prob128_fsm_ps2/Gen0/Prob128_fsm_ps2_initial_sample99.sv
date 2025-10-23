module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output done
);

reg [1:0] state; // 2-bit state register
reg [7:0] byte1, byte2; // registers to store the bytes of the message

// state definitions
localparam IDLE = 2'b00;
localparam BYTE1 = 2'b01;
localparam BYTE2 = 2'b10;
localparam BYTE3 = 2'b11;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        done <= 1'b0;
    end else begin
        case (state)
            IDLE: begin
                if (in[3]) begin
                    byte1 <= in;
                    state <= BYTE1;
                end
            end
            BYTE1: begin
                byte2 <= in;
                state <= BYTE2;
            end
            BYTE2: begin
                state <= BYTE3;
            end
            BYTE3: begin
                done <= 1'b1;
                state <= IDLE;
            end
            default: state <= IDLE;
        endcase
    end
end

always @(posedge clk) begin
    if (state == IDLE && reset == 0) begin
        done <= 1'b0;
    end
end

endmodule