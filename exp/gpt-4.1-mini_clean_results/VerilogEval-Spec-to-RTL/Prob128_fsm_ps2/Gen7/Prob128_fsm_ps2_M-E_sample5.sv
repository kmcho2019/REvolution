module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    reg [1:0] byte_count;      // Counts 0 to 3 bytes received
    reg in_message;            // Flag indicating if currently within a 3-byte message

    always @(posedge clk) begin
        if (reset) begin
            byte_count <= 2'b00;
            in_message <= 1'b0;
            done <= 1'b0;
        end else begin
            done <= 1'b0; // default no done unless at third byte
            if (!in_message) begin
                // Wait for start byte with in[3] == 1
                if (in[3]) begin
                    in_message <= 1'b1;
                    byte_count <= 2'b01; // first byte received
                end
            end else begin
                // Already in message, increment count
                if (byte_count == 2'b10) begin
                    // Receiving third byte now
                    done <= 1'b1;      // assert done in this cycle
                    in_message <= 1'b0; 
                    byte_count <= 2'b00;
                end else begin
                    byte_count <= byte_count + 1'b1;
                end
            end
        end
    end

endmodule