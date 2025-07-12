module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

reg [1:0] byte_count;

// Initialize byte_count, out_bytes, and done on reset
always @(posedge clk) begin
    if (reset) begin
        byte_count <= 0;
        out_bytes <= 0;
        done <= 0;
    end
end

// Update byte_count and out_bytes based on the current state
always @(posedge clk) begin
    if (~reset) begin
        case (byte_count)
            2'b00: begin
                if (in[3] == 1'b1) begin
                    out_bytes[23:16] <= in;
                    byte_count <= 2'b01;
                end
                done <= 0;
            end
            2'b01: begin
                out_bytes[15:8] <= in;
                byte_count <= 2'b10;
                done <= 0;
            end
            2'b10: begin
                out_bytes[7:0] <= in;
                byte_count <= 2'b00;
                done <= 1;
            end
        endcase
    end
end

endmodule