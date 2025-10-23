module TopModule(
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

reg [1:0] state;
reg [1:0] next_state;

always @(posedge clk) begin
    if (~resetn) begin
        state <= 2'b00; // reset to state A
    end else begin
        state <= next_state;
    end
end

always @(*) begin
    case (state)
        2'b00: // state A
            if (r[0]) begin
                next_state = 2'b01; // go to state B
            end else if (r[1]) begin
                next_state = 2'b10; // go to state C
            end else if (r[2]) begin
                next_state = 2'b11; // go to state D
            end else begin
                next_state = 2'b00; // stay in state A
            end
        2'b01: // state B
            if (r[0]) begin
                next_state = 2'b01; // stay in state B
            end else begin
                next_state = 2'b00; // go to state A
            end
        2'b10: // state C
            if (r[1]) begin
                next_state = 2'b10; // stay in state C
            end else begin
                next_state = 2'b00; // go to state A
            end
        2'b11: // state D
            // This state will not be used according to the provided state diagram.
            next_state = 2'b00; // go to state A
        default: next_state = 2'b00;
    endcase
end

assign g[0] = (state == 2'b01); // output g0 depends on state B
assign g[1] = (state == 2'b10); // output g1 depends on state C
assign g[2] = 1'b0; // output g2 is always 0, as state D is not used.

endmodule