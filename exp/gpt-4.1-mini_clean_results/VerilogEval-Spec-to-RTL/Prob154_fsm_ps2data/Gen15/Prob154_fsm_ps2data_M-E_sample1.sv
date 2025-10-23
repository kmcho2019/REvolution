module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    reg [1:0] byte_cnt; // counts received bytes in current message: 0..2

    always @(posedge clk) begin
        if (reset) begin
            byte_cnt  <= 2'd0;
            out_bytes <= 24'd0;
            done      <= 1'b0;
        end else begin
            done <= 1'b0; // default done low each cycle

            if (byte_cnt == 2'd0) begin
                // Waiting for start byte with in[3] == 1
                if (in[3]) begin
                    // Capture start byte at MSB of out_bytes
                    out_bytes <= {in, 16'd0};
                    byte_cnt <= 2'd1;
                end
                // else remain at 0 waiting for start byte
            end else begin
                // Byte_cnt = 1 or 2: shift in new byte into lower position
                out_bytes <= {out_bytes[15:0], in};
                if (byte_cnt == 2'd2) begin
                    done <= 1'b1;  // done asserted immediately after 3rd byte
                    byte_cnt <= 2'd0;
                end else begin
                    byte_cnt <= byte_cnt + 1'b1;
                end
            end
        end
    end

endmodule