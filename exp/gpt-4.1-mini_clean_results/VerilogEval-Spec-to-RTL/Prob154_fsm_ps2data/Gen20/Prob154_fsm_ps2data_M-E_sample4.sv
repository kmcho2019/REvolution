module TopModule (
    input         clk,
    input         reset,
    input  [7:0]  in,
    output reg [23:0] out_bytes,
    output reg        done
);

    reg [1:0] byte_count; // counts down from 2 to 0 when collecting bytes

    always @(posedge clk) begin
        if (reset) begin
            out_bytes <= 24'd0;
            byte_count <= 2'd0;
            done <= 1'b0;
        end else begin
            done <= 1'b0;  // default done low each cycle

            if (byte_count == 2'd0) begin
                // Looking for start byte where in[3]==1
                if (in[3]) begin
                    // Start collecting: put first byte in highest byte position
                    out_bytes <= {in, 16'd0};
                    byte_count <= 2'd2; // expect 2 more bytes
                end
                // else stay idle, discard bytes
            end else begin
                // Collecting: shift out_bytes left by 8 and insert new byte
                out_bytes <= {out_bytes[15:0], in};
                byte_count <= byte_count - 1'b1;

                if (byte_count == 2'd1) begin
                    // Just collected the last (third) byte, pulse done
                    done <= 1'b1;
                end
            end
        end
    end

endmodule