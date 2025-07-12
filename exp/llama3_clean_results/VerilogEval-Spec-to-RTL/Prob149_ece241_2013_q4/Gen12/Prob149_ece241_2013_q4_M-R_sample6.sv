module TopModule(
    input clk,
    input reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

reg [2:0] prev_s; // Register to store previous sensor state

// Sequential logic to update previous sensor state
always @(posedge clk) begin
    if (reset) begin
        // Reset to state equivalent to low water level
        prev_s <= 3'b000;
    end else begin
        // Store previous sensor state
        prev_s <= s;
    end
end

// Combinational logic to determine level signals
assign level_above_high = (s[2] == 1'b1);
assign level_above_middle = (s[1] == 1'b1) && (!level_above_high);
assign level_above_low = (s[0] == 1'b1) && (!(level_above_high || level_above_middle));

// Combinational logic to determine output signals (fr2, fr1, fr0)
assign fr2 = (!level_above_high) && (!level_above_middle) && (!level_above_low);
assign fr1 = (!level_above_high) && (!level_above_middle);
assign fr0 = (!level_above_high);

// Combinational logic to determine supplemental flow rate (dfr) signal
assign dfr = (s > prev_s) && (s != 3'b000);

endmodule