module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    reg [1:0] cnt;
    reg [1:0] cnt_delayed;

    always @(posedge clk) begin
        if (reset) begin
            cnt <= 2'b0;
            cnt_delayed <= 2'b0;
            done <= 1'b0;
        end else begin
            // Delay counter by 1 cycle for timing optimization
            cnt_delayed <= cnt;
            
            // Only evaluate done when counter changes (power optimization)
            done <= (cnt_delayed == 2'b10);
            
            // Simplified counter increment with wrap-around
            if (cnt == 2'b0) begin
                if (in[3]) cnt <= 2'b01;  // Start new message
            end else begin
                cnt <= cnt + 1'b1;  // Will automatically wrap from 3 to 0
            end
        end
    end

endmodule