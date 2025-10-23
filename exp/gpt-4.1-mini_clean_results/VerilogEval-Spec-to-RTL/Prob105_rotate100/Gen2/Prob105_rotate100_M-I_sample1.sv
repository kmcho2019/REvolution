module TopModule (
    input          clk,
    input          load,
    input   [1:0]  ena,
    input   [99:0] data,
    output  reg [99:0] q
);

wire update_en = load | (ena == 2'b01) | (ena == 2'b10);

always @(posedge clk) begin
    if (update_en) begin
        if (load) begin
            q <= data;
        end else begin
            case (ena)
                2'b01: // rotate right by 1
                    q <= {q[0], q[99:1]};
                2'b10: // rotate left by 1
                    q <= {q[98:0], q[99]};
                default:
                    q <= q; // This case won't be reached since update_en guards it
            endcase
        end
    end
    // When update_en is low, q keeps its previous value, so no toggling
end

endmodule