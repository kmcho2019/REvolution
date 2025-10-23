module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    reg [1:0] byte_counter;

    always @(posedge clk) begin
        if (reset) begin
            byte_counter <= 2'b0;
            done <= 1'b0;
        end else begin
            // Default assignment
            done <= 1'b0;

            // Counter logic
            if (byte_counter == 2'b0) begin
                // Waiting for start byte
                if (in[3] == 1'b1) begin
                    byte_counter <= 2'b01;
                end
            end else begin
                // Counting message bytes
                if (byte_counter == 2'b10) begin
                    // Third byte received - assert done and reset
                    done <= 1'b1;
                    byte_counter <= 2'b0;
                end else begin
                    byte_counter <= byte_counter + 1'b1;
                end
            end
        end
    end

endmodule