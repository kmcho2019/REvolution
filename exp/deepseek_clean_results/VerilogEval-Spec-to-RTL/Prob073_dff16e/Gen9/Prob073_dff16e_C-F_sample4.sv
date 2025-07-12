module TopModule (
    input clk,
    input resetn,
    input [1:0] byteena,
    input [15:0] d,
    output reg [15:0] q
);

// synthesis translate_off
initial q = 16'b0; // Simulation only initialization
// synthesis translate_on

always @(posedge clk) begin
    if (!resetn) begin
        q <= 16'b0;
    end else begin
        /* synthesis clock_gate = byteena[1] */
        if (byteena[1]) q[15:8] <= d[15:8];
        
        /* synthesis clock_gate = byteena[0] */
        if (byteena[0]) q[7:0] <= d[7:0];
    end
end

endmodule