module freq_divbyodd #(
    parameter NUM_DIV = 5  // Must be odd number
) (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

// Check if NUM_DIV is odd
initial begin
    if (NUM_DIV % 2 == 0) begin
        $error("NUM_DIV must be an odd number");
        $finish;
    end
end

reg [31:0] counter;
reg clk_div_reg;
wire [31:0] half_period = (NUM_DIV - 1)/2;  // Explicit division

// Counter logic - increments on both edges
always @(posedge clk or negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 0;
    end else begin
        if (counter == NUM_DIV - 1)
            counter <= 0;
        else
            counter <= counter + 1;
    end
end

// Clock generation logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_div_reg <= 0;
    end else begin
        if (counter == half_period || counter == NUM_DIV - 1)
            clk_div_reg <= ~clk_div_reg;
    end
end

assign clk_div = clk_div_reg;

endmodule