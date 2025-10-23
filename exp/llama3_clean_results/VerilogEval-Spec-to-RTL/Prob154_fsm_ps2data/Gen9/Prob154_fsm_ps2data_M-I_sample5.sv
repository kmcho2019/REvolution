module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

reg [1:0] byte_count;

always @(posedge clk) begin
    if (reset) begin
        byte_count <= 0;
        out_bytes <= 0;
        done <= 0;
    end else begin
        case (byte_count)
            0: begin
                if (in[3]) begin
                    out_bytes[23:16] <= in;
                    byte_count <= 1;
                end
            end
            1: begin
                out_bytes[15:8] <= in;
                byte_count <= 2;
            end
            2: begin
                out_bytes[7:0] <= in;
                byte_count <= 0;
                done <= 1;
            end
            default: begin
                byte_count <= 0;
                done <= 0;
            end
        endcase
    end
end

// Add a combinational logic to reduce unnecessary switching in out_bytes
always @(*) begin
    if (done) begin
        // out_bytes is only valid when done is asserted
    end else begin
        // out_bytes is not valid when done is not asserted
        out_bytes <= 0;
    end
end

endmodule