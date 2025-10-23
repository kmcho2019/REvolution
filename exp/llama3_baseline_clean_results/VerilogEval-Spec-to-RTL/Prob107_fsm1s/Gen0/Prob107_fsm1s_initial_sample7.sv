module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

reg [0:0] state; // two-state encoding (0 for B and 1 for A)
reg [0:0] next_state;

always @(*) begin
    case (state)
        0: begin // state B
            if (in == 1'b0) next_state = 0; // stay in B
            else next_state = 0; // stay in B
            out = 1'b1;
        end
        1: begin // state A
            if (in == 1'b0) next_state = 0; // go to B
            else next_state = 1; // stay in A
            out = 1'b0;
        end
        default: begin
            next_state = 0; // default to B
            out = 1'b1;
        end
    endcase
end

always @(posedge clk) begin
    if (reset) state = 0; // synchronous reset to B
    else state = next_state;
end

endmodule