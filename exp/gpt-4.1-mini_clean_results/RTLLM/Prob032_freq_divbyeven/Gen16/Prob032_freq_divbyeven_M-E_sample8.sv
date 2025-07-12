module freq_diveven #(
    parameter integer NUM_DIV = 4  // Must be even
)(
    input  wire clk,
    input  wire rst_n,
    output reg  clk_div
);

    // Compile-time check for even NUM_DIV
    initial begin
        if (NUM_DIV % 2 != 0) begin
            $error("Parameter NUM_DIV must be an even number.");
            $finish;
        end
    end

    reg [3:0] cnt = 0;
    reg direction = 1'b1; // 1 = counting up, 0 = counting down

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt     <= 4'd0;
            clk_div <= 1'b0;
            direction <= 1'b1;
        end else begin
            if (direction) begin
                // Counting up
                if (cnt == (NUM_DIV/2 - 1)) begin
                    direction <= 1'b0;  // Start counting down next cycle
                    clk_div <= ~clk_div; // Toggle output at top count
                    cnt <= cnt - 1;      // Change direction and decrement next
                end else begin
                    cnt <= cnt + 1;
                end
            end else begin
                // Counting down
                if (cnt == 0) begin
                    direction <= 1'b1;  // Start counting up next cycle
                    clk_div <= ~clk_div; // Toggle output at bottom count
                    cnt <= cnt + 1;      // Change direction and increment next
                end else begin
                    cnt <= cnt - 1;
                end
            end
        end
    end

endmodule