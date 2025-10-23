module freq_diveven #(
    parameter NUM_DIV = 2,  // Even number division factor
    parameter WIDTH = $clog2(NUM_DIV)  // Counter width adjusted based on NUM_DIV
) (
    input clk,        // Input clock signal
    input rst_n,      // Active-low reset signal
    output reg clk_div // Divided clock output signal
);

reg [WIDTH-1:0] cnt;        // Counter to track clock cycles
reg [WIDTH-1:0] mid_cnt;    // Counter for mid-point of division
reg prev_cnt;               // Previous count value

// Validate NUM_DIV as an even number and greater than 1 at compile-time
initial begin
    if (NUM_DIV <= 1) begin
        $error("NUM_DIV must be greater than 1.");
        $finish;
    end
    if (NUM_DIV % 2!= 0) begin
        $error("NUM_DIV must be an even number.");
        $finish;
    end
end

// Calculate mid-point for division
assign mid_cnt = (NUM_DIV / 2) - 1;

// Sequential logic for counter update
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= '0;
        prev_cnt <= '0;
    end else begin
        prev_cnt <= cnt;
        if (cnt == (NUM_DIV - 1)) begin
            cnt <= '0;
        end else begin
            cnt <= cnt + 1;
        end
    end
end

// Combinational logic for divided clock output
assign clk_div = (cnt == mid_cnt && prev_cnt == (mid_cnt - 1))? ~clk_div : 
                 (cnt == (NUM_DIV - 1) && prev_cnt == (NUM_DIV - 2))? ~clk_div : 
                 clk_div;

endmodule