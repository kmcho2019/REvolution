module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    reg [1:0] byte_count; // 0: searching, 1~3: bytes received in current message

    always @(posedge clk) begin
        if (reset) begin
            byte_count <= 2'd0;
            done <= 1'b0;
        end else begin
            if (byte_count == 2'd0) begin
                // searching for first byte with in[3] = 1
                if (in[3] == 1'b1) begin
                    byte_count <= 2'd1;
                    done <= 1'b0;
                end else begin
                    done <= 1'b0;
                end
            end else if (byte_count < 2'd3) begin
                byte_count <= byte_count + 1'b1;
                done <= 1'b0;
            end else begin
                // byte_count == 3, done this cycle and reset counter
                byte_count <= 2'd0;
                done <= 1'b1;
            end
        end
    end

endmodule