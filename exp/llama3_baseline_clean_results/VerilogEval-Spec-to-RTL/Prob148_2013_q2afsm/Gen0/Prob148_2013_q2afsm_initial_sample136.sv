module TopModule(
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

reg [1:0] current_state;
reg [1:0] next_state;

// State table
always @(*) begin
    case (current_state)
        2'b00: // State A
            if (~r[0] && ~r[1] && ~r[2])
                next_state = 2'b00;
            else if (r[0])
                next_state = 2'b01;
            else if (r[1])
                next_state = 2'b10;
            else if (r[2])
                next_state = 2'b00; // Same as A, based on the description
        2'b01: // State B
            if (r[0])
                next_state = 2'b01;
            else
                next_state = 2'b00;
        2'b10: // State C
            if (r[1])
                next_state = 2'b10;
            else
                next_state = 2'b00;
        2'b11: // State D
            next_state = 2'b00; // Since it seems to act like A in the description
        default:
            next_state = 2'b00;
    endcase
end

// State flip-flops
always @(posedge clk) begin
    if (~resetn) begin
        current_state <= 2'b00;
    end else begin
        current_state <= next_state;
    end
end

// Output logic
assign g[0] = (current_state == 2'b01);
assign g[1] = (current_state == 2'b10);
assign g[2] = 1'b0; // Since state D seems to be the same as A

endmodule