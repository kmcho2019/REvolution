module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

    wire update_en = load | (ena == 2'b01) | (ena == 2'b10);

    always @(posedge clk) begin
        if (update_en) begin
            if (load) begin
                // Load data synchronously
                q <= data;
            end else begin
                case (ena)
                    2'b01: q <= {q[0], q[99:1]};  // Rotate right
                    2'b10: q <= {q[98:0], q[99]};  // Rotate left
                    default: q <= q; // This case won't occur due to update_en gating
                endcase
            end
        end
        // else no register update -> no toggling, power saving
    end

endmodule