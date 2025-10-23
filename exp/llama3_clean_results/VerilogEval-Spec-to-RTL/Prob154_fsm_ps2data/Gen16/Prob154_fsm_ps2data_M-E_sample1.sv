module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

reg valid_byte;
reg [7:0] byte1, byte2, byte3;
reg byte1_valid, byte2_valid, byte3_valid;

always @(posedge clk) begin
    if (reset) begin
        valid_byte <= 0;
        byte1 <= 0;
        byte2 <= 0;
        byte3 <= 0;
        byte1_valid <= 0;
        byte2_valid <= 0;
        byte3_valid <= 0;
        out_bytes <= 0;
        done <= 0;
    end else begin
        // Byte Validation Stage
        valid_byte <= in[3];

        // Byte Accumulation Stage
        if (valid_byte) begin
            byte1 <= in;
            byte1_valid <= 1;
        end else if (byte1_valid) begin
            byte2 <= in;
            byte2_valid <= 1;
        end else if (byte2_valid) begin
            byte3 <= in;
            byte3_valid <= 1;
        end

        // Message Completion Stage
        if (byte3_valid) begin
            out_bytes <= {byte1, byte2, byte3};
            done <= 1;
            byte1_valid <= 0;
            byte2_valid <= 0;
            byte3_valid <= 0;
        end else begin
            done <= 0;
        end
    end
end

endmodule