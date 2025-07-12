module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    // State encoding - binary for compactness
    localparam IDLE  = 2'b00;
    localparam BYTE2 = 2'b01;
    localparam BYTE3 = 2'b10;

    reg [1:0] state;
    reg [23:0] msg_buffer;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            msg_buffer <= 24'b0;
            done <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    done <= 1'b0;
                    if (in[3]) begin
                        state <= BYTE2;
                        msg_buffer <= {16'b0, in};  // Store first byte
                    end
                end
                BYTE2: begin
                    state <= BYTE3;
                    msg_buffer <= {msg_buffer[15:0], in};  // Shift in second byte
                end
                BYTE3: begin
                    state <= IDLE;
                    out_bytes <= {msg_buffer[15:0], in};  // Capture all 3 bytes
                    done <= 1'b1;
                end
            endcase
        end
    end

endmodule