module TopModule #(
    parameter RESET_VALUE = 1'b0  // Configurable reset value
)(
    input  clk,
    input  ar,    // Active-high async reset
    input  d,
    output reg q
);

// synthesis translate_off
initial q = RESET_VALUE;  // Simulation initialization
// synthesis translate_on

always @(posedge clk or posedge ar) begin
    if (ar) begin
        q <= RESET_VALUE;  // Async reset with configurable value
    end else begin
        q <= d;           // Positive edge-triggered sampling
    end
end

// synthesis attribute async_set_reset "ar"
// synthesis attribute sync_set_reset "none"

endmodule