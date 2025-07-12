module freq_divbyodd #(
    parameter NUM_DIV = 5  // Must be odd number
) (
    input wire clk,
    input wire rst_n,
    output reg clk_div
);

// Check if NUM_DIV is odd
initial begin
    if (NUM_DIV % 2 == 0) begin
        $error("NUM_DIV must be an odd number");
        $finish;
    end
end

reg [31:0] counter;
wire [31:0] half_period = (NUM_DIV - 1) >> 1;  // (N-1)/2

always @(posedge clk or negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 0;
        clk_div <= 0;
    end
    else begin
        if (counter == NUM_DIV - 1) begin
            counter <= 0;
        end
        else begin
            counter <= counter + 1;
        end

        // Toggle at (N-1)/2 and (N-1) counts
        if (counter == half_period || counter == NUM_DIV - 1) begin
            clk_div <= ~clk_div;
        end
    end
end

endmodule