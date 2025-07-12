module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    reg [1:0] cnt;
    reg found_start;

    always @(posedge clk) begin
        if (reset) begin
            cnt <= 2'b0;
            done <= 1'b0;
            found_start <= 1'b0;
        end else begin
            // Default assignments
            done <= 1'b0;
            found_start <= 1'b0;

            // Detect start of new message
            if (cnt == 2'b0 && in[3]) begin
                cnt <= 2'b01;
                found_start <= 1'b1;
            end 
            // Continue counting message bytes
            else if (cnt != 2'b0) begin
                cnt <= cnt + 1'b1;
                // Assert done when third byte is received
                if (cnt == 2'b10) begin
                    done <= 1'b1;
                    cnt <= 2'b0;
                end
            end
        end
    end

endmodule