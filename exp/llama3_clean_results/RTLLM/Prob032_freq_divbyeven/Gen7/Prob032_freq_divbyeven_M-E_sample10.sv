// Counter Module
module counter_mod(
    input clk,
    input rst_n,
    output reg threshold_reached
);

parameter NUM_DIV = 8; // Must be an even number
parameter COUNTER_BITS = 4; // Number of bits for the counter

reg [COUNTER_BITS-1:0] cnt; // Counter register

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 0;
        threshold_reached <= 0;
    end else if (cnt == (NUM_DIV / 2 - 1)) begin
        cnt <= 0;
        threshold_reached <= 1;
    end else begin
        cnt <= cnt + 1;
        threshold_reached <= 0;
    end
end

endmodule

// Toggle Module
module toggle_mod(
    input clk,
    input toggle_in,
    input rst_n,
    output reg clk_div
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_div <= 0;
    end else if (toggle_in) begin
        clk_div <= ~clk_div;
    end
end

endmodule

// freq_diveven Module
module freq_diveven(
    input clk,
    input rst_n,
    output reg clk_div
);

wire threshold_reached;

counter_mod #(
   .NUM_DIV(8),
   .COUNTER_BITS(4)
) counter_inst (
   .clk(clk),
   .rst_n(rst_n),
   .threshold_reached(threshold_reached)
);

toggle_mod toggle_inst (
   .clk(clk),
   .toggle_in(threshold_reached),
   .rst_n(rst_n),
   .clk_div(clk_div)
);

endmodule