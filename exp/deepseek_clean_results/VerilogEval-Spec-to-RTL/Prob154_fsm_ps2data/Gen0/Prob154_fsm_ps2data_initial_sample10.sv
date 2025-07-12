module TopModule(
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
    reg [23:0] msg_buffer;
    reg [1:0] byte_count;

    // State transition logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            msg_buffer <= 24'b0;
            byte_count <= 2'b0;
            done <= 1'b0;
        end else begin
            state <= next_state;
            
            case (state)
                IDLE: begin
                    if (in[3]) begin
                        msg_buffer[23:16] <= in;
                        byte_count <= 2'b1;
                    end
                    done <= 1'b0;
                end
                BYTE1: begin
                    msg_buffer[15:8] <= in;
                    byte_count <= byte_count + 1;
                    done <= 1'b0;
                end
                BYTE2: begin
                    msg_buffer[7:0] <= in;
                    byte_count <= 2'b0;
                    done <= 1'b1;
                    out_bytes <= {msg_buffer[23:16], msg_buffer[15:8], in};
                end
                default: begin
                    done <= 1'b0;
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