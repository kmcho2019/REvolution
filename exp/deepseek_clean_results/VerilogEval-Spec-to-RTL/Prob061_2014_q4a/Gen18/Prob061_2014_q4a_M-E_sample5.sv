module TopModule (
    input clk,
    input w,
    input R,
    input E,
    input L,
    output reg Q
);

// State encoding
localparam HOLD = 1'b0;
localparam SHIFT = 1'b1;

reg state;

always @(posedge clk) begin
    // State transition logic
    if (L) begin
        state <= HOLD;  // Reset state after load
        Q <= R;
    end else begin
        case (state)
            HOLD: state <= E ? SHIFT : HOLD;
            SHIFT: state <= E ? SHIFT : HOLD;
        endcase
        
        // Output logic
        if (state == SHIFT)
            Q <= w;
    end
end

endmodule