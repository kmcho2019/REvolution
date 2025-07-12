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
    if (L) begin
        Q <= R;
        state <= HOLD;  // Return to hold state after load
    end
    else begin
        case (state)
            HOLD: begin
                if (E) state <= SHIFT;
                // Q remains unchanged in hold state
            end
            SHIFT: begin
                Q <= w;
                if (!E) state <= HOLD;
            end
        endcase
    end
end

endmodule