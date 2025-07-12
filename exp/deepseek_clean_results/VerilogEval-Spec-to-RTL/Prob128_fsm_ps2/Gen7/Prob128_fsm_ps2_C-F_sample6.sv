module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    reg [1:0] byte_cnt;

    always @(posedge clk) begin
        if (reset) begin
            byte_cnt <= 2'b0;
            done <= 1'b0;
        end else begin
            // Assert done when third byte is received
            done <= (byte_cnt == 2'b10);
            
            // Update counter
            if (byte_cnt == 2'b0) begin
                // Wait for start byte (in[3] == 1)
                if (in[3]) byte_cnt <= 2'b01;
            end else begin
                // Count up to 3 then reset
                byte_cnt <= (byte_cnt == 2'b10) ? 2'b0 : (byte_cnt + 1'b1);
            end
        end
    end

endmodule