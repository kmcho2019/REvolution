module TopModule (
    input          clk,
    input          load,
    input   [1:0]  ena,
    input   [99:0] data,
    output  reg [99:0] q
);

// Generate clock enable signal for gating register updates
wire reg_en = load | (ena == 2'b01) | (ena == 2'b10);

// Synchronous register with clock gating at RTL level (synthesis tools handle this)
// Only update q when reg_en is high
always @(posedge clk) begin
    if (reg_en) begin
        if (load) begin
            q <= data;
        end else begin
            case (ena)
                2'b01: // rotate right by 1
                    q <= {q[0], q[99:1]};
                2'b10: // rotate left by 1
                    q <= {q[98:0], q[99]};
                default:
                    q <= q; // Not strictly necessary, but explicit
            endcase
        end
    end
    // If reg_en is low, q holds its value by default, no clock toggling inside flip-flops
end

endmodule