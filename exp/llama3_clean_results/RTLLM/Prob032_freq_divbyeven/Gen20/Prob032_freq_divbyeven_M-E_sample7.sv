// Counter module (cnt_mod)
module cnt_mod #(
    parameter NUM_DIV = 4  // Even number division factor
) (
    input clk,        // Input clock signal
    input rst_n,      // Active-low reset signal
    output reg [1:0] cnt_out  // Counter output
);

// Validate NUM_DIV as an even number and greater than 1 at compile-time
initial begin
    if (NUM_DIV % 2 != 0 || NUM_DIV <= 1) begin
        $error("NUM_DIV must be an even number greater than 1.");
        $finish;
    end
end

reg [1:0] cnt;        // 2-bit counter

// Sequential logic for counter update
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= '0;
    end else if (cnt == (NUM_DIV / 2 - 1)) begin
        cnt <= '0;
    end else begin
        cnt <= cnt + 1;
    end
end

assign cnt_out = cnt;

endmodule

// Clock division module (clk_div_mod)
module clk_div_mod (
    input clk,        // Input clock signal
    input cnt_out,    // Counter output from cnt_mod
    output reg clk_div // Divided clock output signal
);

reg prev_cnt_out;

// Sequential logic for divided clock output
always @(posedge clk) begin
    if (cnt_out == (NUM_DIV / 2 - 1) && prev_cnt_out != (NUM_DIV / 2 - 1)) begin
        clk_div <= ~clk_div;
    end
    prev_cnt_out <= cnt_out;
end

endmodule

// Top-level frequency divider module (freq_diveven)
module freq_diveven #(
    parameter NUM_DIV = 4  // Even number division factor
) (
    input clk,        // Input clock signal
    input rst_n,      // Active-low reset signal
    output clk_div    // Divided clock output signal
);

wire [1:0] cnt_out;

cnt_mod #(.NUM_DIV(NUM_DIV)) u_cnt_mod (
    .clk(clk),
    .rst_n(rst_n),
    .cnt_out(cnt_out)
);

clk_div_mod u_clk_div_mod (
    .clk(clk),
    .cnt_out(cnt_out[1]), // Using only the most significant bit
    .clk_div(clk_div)
);

endmodule