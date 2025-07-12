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

localparam HALF_DIV_HIGH = (NUM_DIV - 1)/2;
localparam HALF_DIV_LOW = NUM_DIV - 1;

// Common counter for both edges
reg [31:0] counter;
wire counter_reset = (counter == NUM_DIV - 1) || !rst_n;
wire counter_inc = rst_n;

// Positive edge domain
reg clk_div_pos;

// Negative edge domain
reg clk_div_neg;

// Output generation
assign clk_div = clk_div_pos | clk_div_neg;

// Counter logic (increments on both edges)
always @(posedge clk or negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 0;
    end else begin
        if (counter_reset)
            counter <= 0;
        else
            counter <= counter + 1;
    end
end

// Positive edge toggle generation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_div_pos <= 0;
    end else begin
        if (counter == HALF_DIV_HIGH || counter_reset)
            clk_div_pos <= ~clk_div_pos;
    end
end

// Negative edge toggle generation
always @(negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_div_neg <= 0;
    end else begin
        if (counter == HALF_DIV_LOW || counter_reset)
            clk_div_neg <= ~clk_div_neg;
    end
end

endmodule