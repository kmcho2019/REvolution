module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

// Split rotation into two 50-bit chunks for better timing
wire [49:0] q_upper = q[99:50];
wire [49:0] q_lower = q[49:0];

always @(posedge clk) begin
    if (load) begin
        q <= data;
    end else begin
        case (ena)
            2'b01: begin // Right rotate
                q <= {q[0], q[99:1]};
            end
            2'b10: begin // Left rotate
                q <= {q[98:0], q[99]};
            end
            // default: no change (implicit)
        endcase
    end
end

// Alternative implementation using hierarchical rotation
// This shows the concept but isn't active in this code
// always @(posedge clk) begin
//     if (load) begin
//         q <= data;
//     end else if (ena == 2'b01) begin // Right rotate
//         q <= {q[0], q[99:1]};
//     end else if (ena == 2'b10) begin // Left rotate
//         q <= {q[98:0], q[99]};
//     end
// end

endmodule