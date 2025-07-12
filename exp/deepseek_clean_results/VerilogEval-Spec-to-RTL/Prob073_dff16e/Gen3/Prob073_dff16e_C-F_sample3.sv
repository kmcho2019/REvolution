module TopModule (
    input clk,
    input resetn,
    input [1:0] byteena,
    input [15:0] d,
    output reg [15:0] q
);

always @(posedge clk) begin
    if (!resetn) begin
        q <= 16'b0;
    end else if (|byteena) begin
        case (byteena)
            2'b00: q <= q;  // No change (redundant but explicit)
            2'b01: q <= {q[15:8], d[7:0]};    // Update lower byte
            2'b10: q <= {d[15:8], q[7:0]};    // Update upper byte
            2'b11: q <= d;                    // Update all bytes
        endcase
    end
end

endmodule