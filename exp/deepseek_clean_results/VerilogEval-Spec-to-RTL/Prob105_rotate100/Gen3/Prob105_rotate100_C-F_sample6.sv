module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

always @(posedge clk) begin
    if (load) begin
        q <= data;  // Synchronous load has highest priority
    end
    else begin
        case (ena)
            2'b01: q <= {q[0], q[99:1]};  // Right rotate: LSB becomes MSB
            2'b10: q <= {q[98:0], q[99]}; // Left rotate: MSB becomes LSB
            default: q <= q;               // No change (clock gating opportunity)
        endcase
    end
end

// For timing-critical applications, consider pipelining:
// always @(posedge clk) begin
//     if (load) q <= data;
//     else case (ena)
//         2'b01: q <= {q[0], q[99:1]};
//         2'b10: q <= {q[98:0], q[99]};
//         default: q <= q;
//     endcase
// end
// Additional pipeline registers could be added for very high frequencies

endmodule