module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    reg [1:0] state; // 0=IDLE, 1=BYTE1, 2=BYTE2, 3=BYTE3

    always @(posedge clk) begin
        if (reset) begin
            state <= 2'b00;
            out_bytes <= 24'b0;
            done <= 1'b0;
        end else begin
            done <= 1'b0;
            
            case (state)
                2'b00: begin // IDLE
                    if (in[3]) begin
                        out_bytes[23:16] <= in;
                        state <= 2'b01;
                    end
                end
                2'b01: begin // BYTE1
                    out_bytes[15:8] <= in;
                    state <= 2'b10;
                end
                2'b10: begin // BYTE2
                    out_bytes[7:0] <= in;
                    done <= 1'b1;
                    state <= 2'b00;
                end
                default: state <= 2'b00;
            endcase
        end
    end

    // Output remains don't-care when not done (optimizes power)
    // No need for explicit combinational logic like Example 2
    // since out_bytes is registered and only valid when done=1

endmodule