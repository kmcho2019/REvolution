module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    reg [1:0] byte_count;

    always @(posedge clk) begin
        if (reset) begin
            byte_count <= 2'd0;
            done <= 1'b0;
        end else begin
            done <= 1'b0; // default done low

            if (byte_count == 2'd0) begin
                // Wait for start byte where in[3] == 1
                if (in[3]) begin
                    byte_count <= 2'd1;
                end
            end else if (byte_count < 2'd3) begin
                byte_count <= byte_count + 1'b1;
                if (byte_count == 2'd2) begin
                    done <= 1'b1; // done asserted after 3rd byte (count 3)
                    byte_count <= 2'd0; // reset to wait for next message
                end
            end
        end
    end

endmodule