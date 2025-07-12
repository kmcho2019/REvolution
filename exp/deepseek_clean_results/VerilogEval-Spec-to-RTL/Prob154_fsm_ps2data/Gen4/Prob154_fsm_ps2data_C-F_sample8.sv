module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output done
);

    reg [1:0] byte_cnt;

    // Combinational done signal for better timing
    assign done = (byte_cnt == 2'b10);

    always @(posedge clk) begin
        if (reset) begin
            byte_cnt <= 2'b0;
        end else begin
            case (byte_cnt)
                2'b00: begin // Waiting for start byte
                    if (in[3]) begin
                        out_bytes[23:16] <= in;
                        byte_cnt <= 2'b01;
                    end
                end
                2'b01: begin // First byte received
                    out_bytes[15:8] <= in;
                    byte_cnt <= 2'b10;
                end
                2'b10: begin // Second byte received
                    out_bytes[7:0] <= in;
                    byte_cnt <= 2'b00;
                end
                default: byte_cnt <= 2'b00;
            endcase
        end
    end

endmodule