module DatapathModule (
  input clk,
  input [7:0] in,
  input reset,
  output reg [23:0] out_bytes,
  output reg done
);

// Define states
parameter IDLE = 2'b00, FIRST_BYTE = 2'b01, SECOND_BYTE = 2'b10, THIRD_BYTE = 2'b11;
reg [1:0] state, next_state;

always @(*) begin
    case(state)
        IDLE: begin
            if (in[3] == 1) begin
                next_state = FIRST_BYTE;
            end else begin
                next_state = IDLE;
            end
        end
        FIRST_BYTE: begin
            next_state = SECOND_BYTE;
        end
        SECOND_BYTE: begin
            next_state = THIRD_BYTE;
        end
        THIRD_BYTE: begin
            next_state = IDLE;
        end
    endcase
end

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= IDLE;
        out_bytes <= 24'b0;
        done <= 0;
    end else begin
        state <= next_state;

        case(state)
            IDLE: begin
                if (in[3] == 1) begin
                    out_bytes <= 24'b0;
                end
            end
            FIRST_BYTE: begin
                out_bytes[23:16] <= in;
            end
            SECOND_BYTE: begin
                out_bytes[15:8] <= in;
            end
            THIRD_BYTE: begin
                out_bytes[7:0] <= in;
                done <= 1;
            end
        endcase
    end
end

endmodule