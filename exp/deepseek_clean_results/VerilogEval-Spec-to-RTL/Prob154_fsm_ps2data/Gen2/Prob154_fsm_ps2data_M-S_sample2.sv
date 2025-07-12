module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    // State definitions
    reg [1:0] state;
    localparam IDLE = 2'b00;
    localparam BYTE2 = 2'b01;
    localparam BYTE3 = 2'b10;

    reg [23:0] msg_buffer;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            msg_buffer <= 24'b0;
            done <= 0;
        end else begin
            done <= 0;
            
            case (state)
                IDLE: begin
                    if (in[3]) begin
                        state <= BYTE2;
                        msg_buffer <= {16'b0, in};
                    end
                end
                BYTE2: begin
                    state <= BYTE3;
                    msg_buffer <= {msg_buffer[15:0], in};
                end
                BYTE3: begin
                    state <= IDLE;
                    msg_buffer <= {msg_buffer[15:0], in};
                    done <= 1;
                    out_bytes <= {msg_buffer[15:0], in};
                end
            endcase
        end
    end

endmodule