module TopModule (
    input        clk,
    input        areset,
    input        load,
    input        ena,
    input  [3:0] data,
    output reg [3:0] q
);

// Sequential logic with asynchronous positive-edge reset
always @(posedge clk or posedge areset) begin
    if (areset)
        q <= 4'b0;
    else begin
        if (load)
            q <= data;                  // Load has highest priority
        else if (ena)
            q <= {1'b0, q[3:1]};       // Shift right with zero fill at MSB
        // else hold current q
    end
end

endmodule