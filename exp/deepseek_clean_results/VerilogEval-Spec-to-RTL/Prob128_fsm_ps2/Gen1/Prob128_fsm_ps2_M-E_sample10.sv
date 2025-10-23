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
            if (byte_counter == 2'b00) begin
                // Waiting for start byte
                if (in[3]) begin
                    byte_counter <= 2'b01;
                end
            end else begin
                // Counting bytes
                if (byte_counter == 2'b10) begin
                    // After third byte, reset counter and assert done
                    byte_counter <= 2'b00;
                    done <= 1'b1;
                end else begin
                    byte_counter <= byte_counter + 1'b1;
                end
            end
        end
    end

endmodule