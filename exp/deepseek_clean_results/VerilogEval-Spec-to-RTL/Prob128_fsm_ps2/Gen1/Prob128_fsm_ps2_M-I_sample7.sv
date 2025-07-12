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
            
            // State transition logic
            if (byte_counter == 2'b0) begin
                // Waiting for start byte
                if (in[3]) begin
                    byte_counter <= 2'b1;
                end
            end else if (byte_counter == 2'b1) begin
                // Second byte
                byte_counter <= 2'b2;
            end else begin
                // Third byte - message complete
                done <= 1'b1;
                // Check if next byte starts new message
                if (in[3]) begin
                    byte_counter <= 2'b1;
                end else begin
                    byte_counter <= 2'b0;
                end
            end
        end
    end

endmodule