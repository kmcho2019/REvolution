module TopModule (
    input  wire        clk,
    input  wire        load,
    input  wire        ena,
    input  wire [1:0]  amount,
    input  wire [63:0] data,
    output reg  [63:0] q
);

always @(posedge clk) begin
    if (load) begin
        q <= data;
    end else if (ena) begin
        case (amount)
            2'b00: // shift left by 1 bit
                q <= {q[62:0], 1'b0};
            2'b01: // shift left by 8 bits
                q <= {q[55:0], 8'b0};
            2'b10: // shift right by 1 bit arithmetic
                q <= {q[63], q[63:1]};
            2'b11: // shift right by 8 bits arithmetic
                q <= {{8{q[63]}}, q[63:8]};
            default:
                q <= q; // Should never happen
        endcase
    end
end

endmodule