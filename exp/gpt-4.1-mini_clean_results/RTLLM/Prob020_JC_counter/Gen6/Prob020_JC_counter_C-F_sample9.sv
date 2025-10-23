module JC_counter (
    input  wire       clk,    // Clock input, positive edge triggered
    input  wire       rst_n,  // Asynchronous active-low reset
    output reg [63:0] Q       // 64-bit Johnson counter output
);

// On rising clock edge or falling reset,
// update Q: on reset, clear to 0;
// else shift right by one bit and insert inverse of Q[0] at MSB.
always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        Q <= 64'b0;
    else
        Q <= {~Q[0], Q[63:1]};
end

endmodule