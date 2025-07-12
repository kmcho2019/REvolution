module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    reg inside_msg;
    reg [1:0] byte_count; // Counts bytes 1 to 3

    always @(posedge clk) begin
        if (reset) begin
            inside_msg <= 1'b0;
            byte_count <= 2'b00;
            done <= 1'b0;
        end else begin
            done <= 1'b0; // Default done to 0

            if (!inside_msg) begin
                // Look for start byte where in[3] == 1
                if (in[3] == 1'b1) begin
                    inside_msg <= 1'b1;
                    byte_count <= 2'b01; // First byte received
                end
            end else begin
                // Inside a message, increment byte count
                byte_count <= byte_count + 1'b1;

                if (byte_count == 2'b10) begin
                    // This is the third byte (byte_count == 2 before increment)
                    done <= 1'b1; // Signal done next cycle
                    inside_msg <= 1'b0; // Message complete, search for next
                    byte_count <= 2'b00;
                end
            end
        end
    end

endmodule