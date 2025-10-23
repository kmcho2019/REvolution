module TopModule (
    input clk,
    input areset,
    input load,
    input ena,
    input [3:0] data,
    output reg [3:0] q
);

// Clock gating hint for synthesis
(* clock_gating = "yes" *) reg gated_ena;

always @(*) begin
    gated_ena = ena & ~load;  // Disable shift when load is active
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        q <= 4'b0;
    end else begin
        case ({load, gated_ena})
            2'b10: q <= data;         // Load has priority
            2'b01: q <= {1'b0, q[3:1]}; // Shift right
            default: q <= q;           // Hold value
        endcase
    end
end

endmodule