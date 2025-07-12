module TopModule (
    input         clk,
    input         reset,
    input  [7:0]  in,
    output reg [23:0] out_bytes,
    output reg       done
);

    reg [1:0] byte_count;  // 0 = waiting for sync, 1-3 bytes received

    always @(posedge clk) begin
        if (reset) begin
            byte_count <= 2'd0;
            out_bytes <= 24'd0;
            done <= 1'b0;
        end else begin
            done <= 1'b0; // default done low each cycle
            if (byte_count == 2'd0) begin
                // Waiting for sync byte with in[3] = 1
                if (in[3]) begin
                    out_bytes[23:16] <= in; // first byte
                    byte_count <= 2'd1;
                end
            end else if (byte_count == 2'd1) begin
                out_bytes[15:8] <= in; // second byte
                byte_count <= 2'd2;
            end else if (byte_count == 2'd2) begin
                out_bytes[7:0] <= in;  // third byte
                done <= 1'b1;          // signal done on third byte
                byte_count <= 2'd0;    // reset to waiting state
            end
        end
    end

endmodule