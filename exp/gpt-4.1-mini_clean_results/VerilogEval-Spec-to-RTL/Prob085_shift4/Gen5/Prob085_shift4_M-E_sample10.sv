module TopModule (
    input        clk,
    input        areset,
    input        load,
    input        ena,
    input  [3:0] data,
    output reg [3:0] q
);

// Asynchronous reset block: clears q immediately on areset
always @(posedge clk or posedge areset) begin
    if (areset)
        q <= 4'b0000;
    else begin
        if (load)       // Load has priority
            q <= data;
        else if (ena)   // Shift right with zero inserted at MSB
            q <= {1'b0, q[3:1]};
        else
            q <= q;    // Hold value
    end
end

endmodule