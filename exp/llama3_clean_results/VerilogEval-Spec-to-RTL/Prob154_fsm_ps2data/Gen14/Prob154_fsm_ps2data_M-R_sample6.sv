module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

// Define state parameters
parameter IDLE = 2'b01;
parameter BYTE1 = 2'b10;
parameter BYTE2 = 2'b11;

// Use a 2-bit state register
reg [1:0] state;

// Initialize state to idle on reset
always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        out_bytes <= 24'b0;
        done <= 1'b0;
    end else begin
        case (state)
            IDLE: begin
                if (in[3] == 1'b1) begin
                    out_bytes[23:16] <= in;
                    state <= BYTE1;
                end else begin
                    state <= IDLE;
                end
                done <= 1'b0;
            end
            BYTE1: begin
                out_bytes[15:8] <= in;
                state <= BYTE2;
                done <= 1'b0;
            end
            BYTE2: begin
                out_bytes[7:0] <= in;
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