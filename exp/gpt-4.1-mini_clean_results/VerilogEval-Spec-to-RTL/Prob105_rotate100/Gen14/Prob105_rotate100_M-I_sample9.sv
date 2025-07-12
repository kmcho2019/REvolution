module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

    // Clock enable signal: update only on load or valid rotation
    wire update_en = load | (ena == 2'b01) | (ena == 2'b10);

    // Precompute rotations
    wire [99:0] rotate_right = {q[0], q[99:1]};
    wire [99:0] rotate_left  = {q[98:0], q[99]};

    always @(posedge clk) begin
        if (update_en) begin
            if (load) begin
                q <= data;
            end else begin
                case (ena)
                    2'b01: q <= rotate_right;
                    2'b10: q <= rotate_left;
                    default: q <= q; // no rotation
                endcase
            end
        end
        // else hold q (no update, no toggling)
    end

endmodule