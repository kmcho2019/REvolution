module TopModule (
    input wire clk,
    input wire rst_n,
    input wire x,
    input wire y,
    output reg z
);

// State holds the last input pair (x,y)
reg last_x, last_y;

// At reset, initialize last_x and last_y to 0, so z=1 initially
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        last_x <= 1'b0;
        last_y <= 1'b0;
        z <= 1'b1;
    end else begin
        // Update last inputs if changed
        if (x != last_x || y != last_y) begin
            last_x <= x;
            last_y <= y;
        end
        // Output z=1 if current inputs equal stored inputs, else 0
        z <= (x == last_x) && (y == last_y);
    end
end

endmodule