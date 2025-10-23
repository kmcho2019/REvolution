module freq_diveven (
    input clk,
    input rst_n,
    output reg clk_div
);

parameter NUM_DIV = 4;  // Must be even and >= 2

// Validate parameter
initial begin
    if (NUM_DIV[0] || NUM_DIV < 2) begin
        $error("NUM_DIV must be an even number >= 2");
    end
end

reg [3:0] cnt;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 0;
        clk_div <= 0;
    end
    else begin
        if (cnt == NUM_DIV - 1) begin
            cnt <= 0;
        end
        else begin
            cnt <= cnt + 1;
        end

        // Toggle at midpoint for 50% duty cycle
        if (cnt == (NUM_DIV/2 - 1)) begin
            clk_div <= ~clk_div;
        end
    end
end

endmodule