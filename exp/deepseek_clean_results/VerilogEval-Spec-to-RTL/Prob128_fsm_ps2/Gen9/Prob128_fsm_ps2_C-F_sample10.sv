module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    reg [1:0] cnt;

    always @(posedge clk) begin
        if (reset) begin
            cnt <= 2'b0;
            done <= 1'b0;
        end else begin
            // Optimized done generation using direct bit checks
            done <= (cnt == 2'b10);
            
            // Simplified counter logic
            if (cnt == 2'b0) begin
                cnt <= in[3] ? 2'b01 : 2'b00;  // Start new message only if in[3]=1
            end else begin
                cnt <= (cnt == 2'b10) ? 2'b00 : cnt + 1'b1;  // Increment or wrap
            end
        end
    end

endmodule