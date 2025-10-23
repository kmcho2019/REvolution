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
            // Default assignments
            done <= 1'b0;

            if (in[3] || (byte_count != 0)) begin
                if (in[3] && (byte_count == 0)) begin
                    // Start of new message
                    byte_count <= 2'b1;
                end else if (byte_count == 2'b10) begin
                    // Third byte received
                    byte_count <= 2'b0;
                    done <= 1'b1;
                end else if (byte_count != 0) begin
                    // Increment counter
                    byte_count <= byte_count + 1;
                end
            end
        end
    end

endmodule