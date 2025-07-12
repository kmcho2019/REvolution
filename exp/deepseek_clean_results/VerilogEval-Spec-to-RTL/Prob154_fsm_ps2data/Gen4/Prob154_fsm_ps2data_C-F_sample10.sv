module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    // Binary encoded states
    localparam IDLE  = 2'b00;
    localparam BYTE1 = 2'b01;
    localparam BYTE2 = 2'b10;

    reg [1:0] state;
    reg [23:0] msg_buffer;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            msg_buffer <= 24'b0;
            out_bytes <= 24'b0;
            done <= 1'b0;
        end else begin
            // Default assignments
            done <= 1'b0;

            case (state)
                IDLE: begin
                    if (in[3]) begin
                        msg_buffer[23:16] <= in;
                        state <= BYTE1;
                    end
                end

                BYTE1: begin
                    msg_buffer[15:8] <= in;
                    state <= BYTE2;
                end

                BYTE2: begin
                    msg_buffer[7:0] <= in;
                    out_bytes <= msg_buffer;  // Update output only when complete
                    done <= 1'b1;
                    state <= IDLE;
                end

                default: state <= IDLE;
            endcase
        end
    end

endmodule