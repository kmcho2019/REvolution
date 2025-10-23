module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    // Define states
    localparam IDLE = 2'b00;
    localparam BYTE1 = 2'b01;
    localparam BYTE2 = 2'b10;

    reg [1:0] state, next_state;
    reg [23:0] byte_buffer;

    // State transition logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            byte_buffer <= 24'b0;
            done <= 0;
        end else begin
            state <= next_state;
            
            case (state)
                IDLE: begin
                    if (in[3]) begin
                        byte_buffer[23:16] <= in;
                    end
                    done <= 0;
                end
                BYTE1: begin
                    byte_buffer[15:8] <= in;
                    done <= 0;
                end
                BYTE2: begin
                    byte_buffer[7:0] <= in;
                    out_bytes <= {byte_buffer[23:16], byte_buffer[15:8], in};
                    done <= 1;
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: next_state = (in[3]) ? BYTE1 : IDLE;
            BYTE1: next_state = BYTE2;
            BYTE2: next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

endmodule