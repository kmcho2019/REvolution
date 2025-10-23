module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    reg [1:0] byte_count;

    always @(posedge clk) begin
        if (reset) begin
            byte_count <= 2'b0;
            done <= 1'b0;
        end else begin
            // Default assignment
            done <= 1'b0;

            if (in[3] == 1'b1) begin
                // Start of new message
                byte_count <= 2'b0;
            end else if (byte_count == 2'b10) begin
                // Just completed 3-byte message
                done <= 1'b1;
                byte_count <= 2'b0;
            end else begin
                // Count bytes in current message
                byte_count <= byte_count + 1'b1;
            end
        end
    end

endmodule