module TopModule(
    input clk,
    input resetn,
    input [1:0] byteena,
    input [15:0] d,
    output reg [15:0] q
);

always @(posedge clk or negedge resetn) begin
    if (~resetn) begin
        q <= 16'd0;
    end else begin
        case (byteena)
            2'b00: q <= q; // No update
            2'b01: q[7:0] <= d[7:0]; // Update lower byte
            2'b10: q[15:8] <= d[15:8]; // Update upper byte
            2'b11: q <= d; // Update both bytes
        endcase
    end
end

endmodule