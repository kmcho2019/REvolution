module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    reg [1:0] cnt;
    reg counting;

    always @(posedge clk) begin
        if (reset) begin
            cnt <= 2'b0;
            done <= 1'b0;
            counting <= 1'b0;
        end else begin
            // Optimized done signal using direct bit checks
            done <= (cnt == 2'b10);
            
            if (counting) begin
                cnt <= (cnt == 2'b10) ? 2'b0 : cnt + 1'b1;
                counting <= (cnt != 2'b10);  // Stop counting after 3 bytes
            end else if (in[3]) begin
                cnt <= 2'b01;  // Start counting
                counting <= 1'b1;
            end
        end
    end

endmodule