module TopModule (
    input clk,
    input resetn,
    input [1:0] byteena,
    input [15:0] d,
    output reg [15:0] q
);

always @(posedge clk) begin
    if (!resetn) begin
        q <= 16'b0;  // Synchronous active-low reset
    end else begin
        case (byteena)
            2'b11: q <= d;            // Full word write
            2'b10: q[15:8] <= d[15:8]; // Upper byte only
            2'b01: q[7:0] <= d[7:0];   // Lower byte only
            2'b00: q <= q;             // No write (explicit for clarity)
        endcase
    end
end

endmodule