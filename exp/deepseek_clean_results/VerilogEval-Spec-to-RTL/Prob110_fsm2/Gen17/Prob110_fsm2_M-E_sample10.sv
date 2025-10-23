module TopModule (
    input clk,
    input areset,
    input j,
    input k,
    output out
);

// One-hot state encoding
reg [1:0] state;  // state[0] = OFF, state[1] = ON

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b01;  // Reset to OFF state (one-hot)
    end else begin
        case (state)
            2'b01: state <= j ? 2'b10 : 2'b01;  // OFF -> ON if j=1, else stay OFF
            2'b10: state <= k ? 2'b01 : 2'b10;  // ON -> OFF if k=1, else stay ON
            default: state <= 2'b01;            // Handle invalid states
        endcase
    end
end

// Output is high only when in ON state
assign out = state[1];

endmodule