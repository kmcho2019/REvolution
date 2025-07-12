module TopModule(
    input clk,
    input reset,
    input in,
    output out
);

reg [0:0] state; // Using 1 bit for encoding states (B=0, A=1)
reg [0:0] next_state;

always @(*) begin
    case (state)
        1'b0: // State B
            begin
                if (in == 1'b0) next_state = 1'b1; // B -> A on in=0
                else next_state = 1'b0; // Stay in B on in=1
            end
        1'b1: // State A
            begin
                if (in == 1'b0) next_state = 1'b0; // A -> B on in=0
                else next_state = 1'b1; // Stay in A on in=1
            end
        default: next_state = 1'b0; // Default next state is B
    endcase
end

always @(posedge clk) begin
    if (reset) state <= 1'b0; // Synchronous reset to state B
    else state <= next_state;
end

// Output logic (Moore machine output depends only on the state)
assign out = (state == 1'b0) ? 1'b1 : 1'b0;

endmodule