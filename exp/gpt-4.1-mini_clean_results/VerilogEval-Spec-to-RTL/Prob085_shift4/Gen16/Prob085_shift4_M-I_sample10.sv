module TopModule (
    input        clk,
    input        areset,
    input        load,
    input        ena,
    input  [3:0] data,
    output reg [3:0] q
);

wire clk_en = load | ena;  // Clock enable to reduce switching when idle

always @(posedge clk or posedge areset) begin
    if (areset) begin
        q <= 4'b0;                 // Asynchronous reset
    end else if (clk_en) begin
        if (load) begin
            q <= data;             // Load has higher priority
        end else begin
            q <= {1'b0, q[3:1]};  // Shift right with zero fill MSB
        end
    end
    // else hold current q (no assignment)
end

endmodule