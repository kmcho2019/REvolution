module TopModule(
    input clk,
    input [7:0] d,
    output reg [7:0] q
);

// Define an always block that triggers on the positive edge of the clock
always @(posedge clk) begin
    // Explicitly update each bit of q based on the corresponding bit of d
    // This approach directly describes the hardware, potentially improving synthesizability
    q[0] <= d[0];
    q[1] <= d[1];
    q[2] <= d[2];
    q[3] <= d[3];
    q[4] <= d[4];
    q[5] <= d[5];
    q[6] <= d[6];
    q[7] <= d[7];
end

endmodule