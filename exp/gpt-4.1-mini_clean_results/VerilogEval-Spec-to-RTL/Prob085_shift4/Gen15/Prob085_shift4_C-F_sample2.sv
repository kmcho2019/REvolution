module TopModule (
    input        clk,
    input        areset,
    input        load,
    input        ena,
    input  [3:0] data,
    output reg [3:0] q
);

// Sequential logic with asynchronous reset and prioritized synchronous load/enable
always @(posedge clk or posedge areset) begin
    if (areset) begin
        q <= 4'b0;               // Asynchronous reset to zero
    end else if (load) begin
        q <= data;               // Load has highest synchronous priority
    end else if (ena) begin
        q <= {1'b0, q[3:1]};    // Shift right with zero fill at MSB
    end
    // else retain current state (no assignment needed)
end

endmodule