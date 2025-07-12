module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    reg [1:0] byte_count; // counts 0..3 bytes received

    always @(posedge clk) begin
        if (reset) begin
            byte_count <= 2'd0;
            out_bytes <= 24'd0;
            done <= 1'b0;
        end else begin
            done <= 1'b0; // default done low

            if (byte_count == 2'd0) begin
                // Waiting for start byte
                if (in[3]) begin
                    out_bytes <= {in, 16'd0};
                    byte_count <= 2'd1;
                end
            end else begin
                // Shift in next byte at lower position
                out_bytes <= {out_bytes[15:0], in};
                if (byte_count == 2'd2) begin
                    done <= 1'b1;
                    byte_count <= 2'd0;
                end else begin
                    byte_count <= byte_count + 1'b1;
                end
            end
        end
    end

endmodule