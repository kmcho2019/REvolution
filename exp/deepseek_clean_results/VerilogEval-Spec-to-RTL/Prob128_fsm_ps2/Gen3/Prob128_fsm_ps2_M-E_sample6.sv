module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    reg [1:0] byte_counter;

    always @(posedge clk) begin
        if (reset) begin
            byte_counter <= 2'b00;
            done <= 1'b0;
        end else begin
            // Default assignment
            done <= 1'b0;

            // Counter logic
            if (in[3] && (byte_counter == 2'b00 || byte_counter == 2'b11)) begin
                // Start new message (either from idle or after completing previous)
                byte_counter <= 2'b01;
            end else if (byte_counter != 2'b00) begin
                // Continue counting through message bytes
                if (byte_counter == 2'b10) begin
                    // Third byte received
                    done <= 1'b1;
                    byte_counter <= in[3] ? 2'b01 : 2'b00;
                end else begin
                    byte_counter <= byte_counter + 1'b1;
                end
            end
        end
    end

endmodule