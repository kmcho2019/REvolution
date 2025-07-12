module TopModule (
    input          clk,
    input          reset,
    input  [7:0]   in,
    output reg [23:0] out_bytes,
    output reg       done
);

    reg [1:0] byte_count; // Counts down bytes remaining after start byte captured

    always @(posedge clk) begin
        if (reset) begin
            byte_count <= 2'b00;
            out_bytes  <= 24'd0;
            done       <= 1'b0;
        end else begin
            done <= 1'b0; // default done low each cycle

            if (byte_count == 2'b00) begin
                // Waiting for start byte
                if (in[3]) begin
                    // Capture first byte, set count to capture 2 more
                    out_bytes <= {in, 16'd0};
                    byte_count <= 2'd2;
                end
                // else stay idle
            end else begin
                // Capture subsequent bytes, shift left by 8 bits and append new byte
                out_bytes <= {out_bytes[15:0], in};
                if (byte_count == 2'd1) begin
                    // This is the last byte: after capturing, done=1 and byte_count=0
                    done <= 1'b1;
                    byte_count <= 2'd0;
                end else begin
                    byte_count <= byte_count - 1'b1;
                end
            end
        end
    end

endmodule