module TopModule (
    input        clk,
    input        areset,
    input        load,
    input        ena,
    input  [3:0] data,
    output reg [3:0] q
);

// Asynchronous reset on posedge areset
always @(posedge clk or posedge areset) begin
    if (areset)
        q <= 4'b0;
    else begin
        // Update only on load or enable to reduce switching
        if (load)
            q <= data;
        else if (ena)
            q <= {1'b0, q[3:1]};
        // else hold state - no assignment to reduce unnecessary toggling
    end
end

endmodule