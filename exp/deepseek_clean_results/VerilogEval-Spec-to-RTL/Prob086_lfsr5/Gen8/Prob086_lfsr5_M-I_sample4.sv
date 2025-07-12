module TopModule (
    input clk,
    input reset,
    output reg [4:0] q
);

parameter INIT_VAL = 5'b00001;

always @(posedge clk) begin
    if (reset) begin
        q <= INIT_VAL;
    end else begin
        q <= {
            q[0],          // New q[4] from q[0]
            q[4],          // New q[3] from q[4]
            q[3] ^ q[0],  // Tapped position
            q[2],          // New q[1] from q[2]
            q[1]           // New q[0] from q[1]
        };
    end
end

endmodule