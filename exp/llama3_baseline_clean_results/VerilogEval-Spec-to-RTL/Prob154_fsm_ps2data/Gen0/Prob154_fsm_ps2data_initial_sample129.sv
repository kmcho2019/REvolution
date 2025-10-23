module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

// Enumerations for states
enum logic [1:0] {IDLE, BYTE1, BYTE2} state, next_state;

// Registers for storing bytes
reg [7:0] byte1, byte2, byte3;

always @(*) begin
    case (state)
        IDLE: begin
            if (in[3] == 1) begin
                next_state = BYTE1;
                byte1 = in;
            end else begin
                next_state = IDLE;
            end
        end
        BYTE1: begin
            next_state = BYTE2;
            byte2 = in;
        end
        BYTE2: begin
            next_state = IDLE;
            byte3 = in;
        end
        default: next_state = IDLE;
    endcase
end

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        out_bytes <= 0;
        done <= 0;
    end else begin
        state <= next_state;
        if (state == BYTE2) begin
            out_bytes <= {byte1, byte2, byte3};
            done <= 1;
        end else begin
            done <= 0;
        end
    end
end

endmodule