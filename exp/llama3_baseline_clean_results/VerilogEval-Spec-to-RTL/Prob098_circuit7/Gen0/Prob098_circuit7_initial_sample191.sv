module TopModule (
    input clk,
    input a,
    output reg q
);

always @(posedge clk) begin
    if (a) begin
        q <= ~q; // Toggle q when a is 1
    end else begin
        // Do nothing, retain the current state of q
    end
end

// To handle the initial condition where q becomes 1 when a is 0
initial begin
    q = 1; // Assuming the first a is 0 at the first positive clock edge
end

endmodule