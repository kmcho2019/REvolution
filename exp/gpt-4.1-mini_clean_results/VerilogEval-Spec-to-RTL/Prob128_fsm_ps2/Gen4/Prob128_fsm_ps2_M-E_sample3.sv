module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    reg start_detected;
    reg [1:0] byte_count; // counts from 0 to 2

    always @(posedge clk) begin
        if (reset) begin
            start_detected <= 1'b0;
            byte_count <= 2'd0;
            done <= 1'b0;
        end else begin
            done <= 1'b0; // default no done

            if (!start_detected) begin
                // Wait for start byte: in[3] == 1
                if (in[3]) begin
                    start_detected <= 1'b1;
                    byte_count <= 2'd1;  // first byte received
                end
            end else begin
                // Already in a message sequence
                byte_count <= byte_count + 2'd1;
                if (byte_count == 2'd2) begin
                    // Third byte just received
                    done <= 1'b1;
                    start_detected <= 1'b0;
                    byte_count <= 2'd0;
                end
            end
        end
    end

endmodule