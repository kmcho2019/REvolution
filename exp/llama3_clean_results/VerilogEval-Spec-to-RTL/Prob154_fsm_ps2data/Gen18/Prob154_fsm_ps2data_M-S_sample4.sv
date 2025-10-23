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
        byte_count <= 2'b00;
        out_bytes <= 24'b0;
        done <= 1'b0;
    end else begin
        done <= 1'b0; // Reset done at the beginning of every cycle
        if (in[3] == 1'b1) begin
            case (byte_count)
                2'b00: begin
                    out_bytes[23:16] <= in;
                    byte_count <= 2'b01;
                end
                2'b01: begin
                    out_bytes[15:8] <= in;
                    byte_count <= 2'b10;
                end
                2'b10: begin
                    out_bytes[7:0] <= in;
                    byte_count <= 2'b00;
                    done <= 1'b1; // Assert done for the third byte
                end
            endcase
        end else if (byte_count != 2'b00) begin
            // If we're not in the first byte and in[3] is 0, reset byte_count
            byte_count <= 2'b00;
        end
    end
end

endmodule