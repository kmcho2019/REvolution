module TopModule(
    input clk,
    input a,
    output reg q
);

always @(posedge clk) begin
    if (a) begin
        q <= ~q; // Toggle q when a is 1
    end else begin
        if (~q) begin // If q is 0 and a is 0, do nothing (keep q as it is)
            // No action needed here as q is already assigned in the always block
        end else begin // If q is already 1, and a is 0, keep it as is
            // No action needed here as q is already assigned in the always block
        end
    end
end

initial begin
    q <= 1; // Initialize q to 1 when the simulation starts
end

endmodule