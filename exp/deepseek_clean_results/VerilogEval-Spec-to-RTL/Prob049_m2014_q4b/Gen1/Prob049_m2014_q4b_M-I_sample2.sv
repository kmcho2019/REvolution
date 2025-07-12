module TopModule (
    input clk,
    input ar_n,  // Active-low asynchronous reset
    input d,
    output reg q
);

// Use active-low reset for better power efficiency
always @(posedge clk or negedge ar_n) begin
    if (!ar_n) begin
        q <= 1'b0;  // Asynchronous reset when ar_n is low
    end else begin
        q <= d;      // Positive edge-triggered data capture
    end
end

// synthesis translate_off
initial begin
    $display("TopModule: Using active-low async reset DFF");
end
// synthesis translate_on

endmodule