module TopModule (
    input  wire clk,  // Positive edge-triggered clock
    input  wire ar,   // Asynchronous reset (active high)
    input  wire d,    // Data input
    output reg  q     // Registered output
);

// Parameters
parameter RESET_POLARITY = 1'b1;  // 1=active high, 0=active low

// Internal signals
reg d_prev;          // For clock gating detection
wire clk_en;         // Clock enable signal

// Clock gating logic - disable clock when input is stable
assign clk_en = (d != d_prev) || ar;

// Low-power DFF with async reset and clock gating
// synthesis attribute USE_LOW_POWER_FF TRUE
always @(posedge clk or posedge ar)
    if (ar == RESET_POLARITY) begin
        q <= 1'b0;
        d_prev <= 1'b0;
    end
    else if (clk_en) begin
        q <= d;
        d_prev <= d;
    end

endmodule