module edge_detect (
    input clk,
    input rst_n,
    input a,
    output reg rise,
    output reg down
);

reg a_prev;
wire a_changed = (a != a_prev);  // Change detector

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        a_prev <= 1'b0;
        {rise, down} <= 2'b00;
    end
    else if (a_changed) begin  // Only update when input changes
        a_prev <= a;
        rise <= ~a_prev & a;   // Shared inversion logic
        down <= a_prev & ~a;   // Same ~a used for both
    end
    else begin
        {rise, down} <= 2'b00; // Clear outputs when no change
    end
end

endmodule