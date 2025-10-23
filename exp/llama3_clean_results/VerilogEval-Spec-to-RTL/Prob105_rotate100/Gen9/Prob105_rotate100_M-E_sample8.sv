module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output [99:0] q
);

reg [99:0] q_reg;

// Barrel Shifter implementation
always @(posedge clk) begin
    if (load) begin
        q_reg <= data;
    end else begin
        case (ena)
            2'b01: // Rotate right by one bit
                q_reg <= {q_reg[0], q_reg[99:1]};
            2'b10: // Rotate left by one bit
                q_reg <= {q_reg[98:0], q_reg[99]};
            default: // No rotation
                q_reg <= q_reg;
        endcase
    end
end

// Alternative implementation using a Barrel Shifter
// wire [99:0] rotated_q;
// barrel_shifter #(.WIDTH(100)) bs (
//     .in(q_reg),
//     .shift(1),
//     .dir(ena[1]), // 1 for left, 0 for right
//     .out(rotated_q)
// );
// always @(posedge clk) begin
//     if (load) begin
//         q_reg <= data;
//     end else if (ena == 2'b01 || ena == 2'b10) begin
//         q_reg <= rotated_q;
//     end
// end

assign q = q_reg;

endmodule

// Barrel Shifter module
module barrel_shifter #(
    parameter WIDTH = 100
) (
    input [WIDTH-1:0] in,
    input [WIDTH-1:0] shift,
    input dir,
    output [WIDTH-1:0] out
);

genvar i;
generate
    for (i = 0; i < WIDTH; i++) begin
        if (dir) begin
            // Left shift
            assign out[i] = in[(i + shift) % WIDTH];
        end else begin
            // Right shift
            assign out[i] = in[(i - shift + WIDTH) % WIDTH];
        end
    end
endgenerate

endmodule