module TopModule(
    input clk,
    input areset,
    input in,
    output out
);

reg [0:0] state; // using 1-bit encoding for states
reg [0:0] next_state;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 1'b1; // reset to state B
    end else begin
        case (state)
            1'b0: // state A
                case (in)
                    1'b0: next_state <= 1'b1; // A (0) --0--> B
                    1'b1: next_state <= 1'b0; // A (0) --1--> A
                endcase
            1'b1: // state B
                case (in)
                    1'b0: next_state <= 1'b0; // B (1) --0--> A
                    1'b1: next_state <= 1'b1; // B (1) --1--> B
                endcase
        endcase
        state <= next_state;
    end
end

assign out = state; // Moore machine output is the current state itself

endmodule