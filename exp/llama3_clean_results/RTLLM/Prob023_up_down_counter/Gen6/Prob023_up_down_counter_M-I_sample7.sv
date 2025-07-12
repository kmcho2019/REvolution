module up_down_counter(
    input clk,
    input reset,
    input up_down,
    output reg [15:0] count
);

// Use a local variable to hold the next count value to potentially reduce area
// by minimizing the number of operations within the always block.
reg [15:0] next_count;

always @(posedge clk) begin
    if (reset) begin
        count <= 16'd0;
    end else begin
        // Simplify the logic to calculate the next count value.
        // This could potentially reduce area and power by minimizing switching.
        next_count = (up_down) ? (count + 1) : (count - 1);
        count <= next_count;
    end
end

endmodule