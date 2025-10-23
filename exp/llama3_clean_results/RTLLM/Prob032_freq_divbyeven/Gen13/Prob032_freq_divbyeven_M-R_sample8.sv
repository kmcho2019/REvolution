module freq_diveven #(
    parameter NUM_DIV = 4  // Even number division factor
) (
    input clk,        // Input clock signal
    input rst_n,      // Active-low reset signal
    output reg clk_div // Divided clock output signal
);

// Validate NUM_DIV as an even number and greater than 1 at compile-time
initial begin
    if (NUM_DIV % 2!= 0) begin
        $error("NUM_DIV must be an even number.");
        $finish;
    end
    if (NUM_DIV < 2) begin
        $error("NUM_DIV must be an even number greater than 1.");
        $finish;
    end
end

reg [7:0] cnt; // Fixed-size counter
reg prev_clk_div;

// Combinational logic for next state
wire cnt_next;
assign cnt_next = (cnt == (NUM_DIV / 2 - 1))? 8'd0 : cnt + 1;

// Sequential logic for register updates
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 8'd0;
        clk_div <= 1'b0;
    end else begin
        cnt <= cnt_next;
        if (cnt_next == 8'd0 && cnt!= 8'd0) begin
            clk_div <= ~clk_div;
        end else begin
            clk_div <= clk_div;
        end
    end
end

endmodule