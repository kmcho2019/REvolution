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
wire [31:0] toggle_point = (NUM_DIV - 1) >> 1;  // (N-1)/2

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 0;
        clk_div <= 0;
    end
    else begin
        if (counter == NUM_DIV - 1) begin
            counter <= 0;
            clk_div <= ~clk_div;
        end
        else begin
            counter <= counter + 1;
            if (counter == toggle_point) begin
                clk_div <= ~clk_div;
            end
        end
    end
end

endmodule