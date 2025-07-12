module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

reg [1:0] state; // state register
reg [1:0] next_state; // next state register

// State table
always @(*) begin
    case (state)
        2'b00: // state A
            if (r[0] == 1'b1) begin
                next_state = 2'b01; // state B
            end else if (r[1] == 1'b1) begin
                next_state = 2'b10; // state C
            end else if (r[2] == 1'b1) begin
                next_state = 2'b11; // state D
            end else begin
                next_state = 2'b00; // state A
            end
        2'b01: // state B
            if (r[0] == 1'b1) begin
                next_state = 2'b01; // state B
            end else begin
                next_state = 2'b00; // state A
            end
        2'b10: // state C
            if (r[1] == 1'b1) begin
                next_state = 2'b10; // state C
            end else begin
                next_state = 2'b00; // state A
            end
        2'b11: // state D
            // This state is not actually reached in the given FSM
            next_state = 2'b00; // state A
    endcase
end

// State flip-flops
always @(posedge clk) begin
    if (~resetn) begin
        state <= 2'b00; // reset to state A
    end else begin
        state <= next_state;
    end
end

// Output logic
assign g[0] = (state == 2'b01); // state B
assign g[1] = (state == 2'b10); // state C
assign g[2] = 1'b0; // state D is not actually reached

endmodule