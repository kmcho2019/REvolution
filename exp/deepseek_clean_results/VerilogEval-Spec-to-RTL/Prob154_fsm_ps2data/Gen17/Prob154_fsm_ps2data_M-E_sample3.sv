module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

    reg [1:0] byte_counter;
    reg capturing;

    always @(posedge clk) begin
        if (reset) begin
            out_bytes <= 24'bx;
            byte_counter <= 2'b0;
            capturing <= 1'b0;
            done <= 1'b0;
        end else begin
            done <= 1'b0;  // Default assignment

            if (!capturing && in[3]) begin
                // Start capturing when in[3]=1 detected
                capturing <= 1'b1;
                out_bytes <= {in, 16'bx};  // Store first byte
                byte_counter <= 2'b1;
            end else if (capturing) begin
                if (byte_counter == 2'b10) begin
                    // Third byte received
                    out_bytes <= {out_bytes[23:16], out_bytes[15:8], in};
                    done <= 1'b1;
                    capturing <= 1'b0;
                    byte_counter <= 2'b0;
                end else begin
                    // Shift in next byte
                    out_bytes <= {out_bytes[23:8], in};
                    byte_counter <= byte_counter + 1;
                end
            end
        end
    end

endmodule