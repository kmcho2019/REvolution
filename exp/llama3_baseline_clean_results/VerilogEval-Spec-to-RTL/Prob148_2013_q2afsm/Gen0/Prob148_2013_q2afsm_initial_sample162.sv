module TopModule(
    input  clk,
    input  resetn,
    input  [2:0] r,
    output [2:0] g
);

// Define the state codes
reg [1:0] current_state;
reg [1:0] next_state;

// State table
always @(*) begin
    case(current_state)
        2'b00: begin // State A
            if(r[0] == 1'b1)
                next_state = 2'b01; // State B
            else if(r[1] == 1'b1)
                next_state = 2'b10; // State C
            else if(r[2] == 1'b1)
                next_state = 2'b00; // State A (no transition for r2 in state A)
            else
                next_state = 2'b00; // State A (no requests)
        end
        2'b01: begin // State B
            if(r[0] == 1'b1)
                next_state = 2'b01; // State B
            else
                next_state = 2'b00; // State A
        end
        2'b10: begin // State C
            if(r[1] == 1'b1)
                next_state = 2'b10; // State C
            else
                next_state = 2'b00; // State A
        end
        default: next_state = 2'b00; // State A (default)
    endcase

    if(!resetn)
        next_state = 2'b00; // Reset to state A
end

// State flip-flops
always @(posedge clk) begin
    current_state <= next_state;
end

// Define the outputs based on the current state
assign g[0] = (current_state == 2'b01); // g0 = 1 in state B
assign g[1] = (current_state == 2'b10); // g1 = 1 in state C
assign g[2] = 1'b0; // g2 is not used in this implementation

endmodule