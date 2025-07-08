module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    // State encoding
    localparam IDLE = 2'b00;
    localparam BYTE2 = 2'b01;
    localparam BYTE3 = 2'b10;

    reg [1:0] state, next_state;
    reg [23:0] byte_buffer;

    // State transition logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            byte_buffer <= 24'b0;
            done <= 1'b0;
        end else begin
            state <= next_state;
            
            case (state)
                IDLE: begin
                    if (in[3]) begin
                        byte_buffer <= {in, 16'b0};
                        done <= 1'b0;
                    end
                end
                BYTE2: begin
                    byte_buffer <= {byte_buffer[23:16], in, 8'b0};
                    done <= 1'b0;
                end
                BYTE3: begin
                    byte_buffer <= {byte_buffer[23:8], in};
                    done <= 1'b1;
                end
                default: begin
                    byte_buffer <= byte_buffer;
                    done <= 1'b0;
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: next_state = (in[3]) ? BYTE2 : IDLE;
            BYTE2: next_state = BYTE3;
            BYTE3: next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

    // Output assignment
    always @(*) begin
        out_bytes = (done) ? byte_buffer : 24'bx;
    end

endmodule