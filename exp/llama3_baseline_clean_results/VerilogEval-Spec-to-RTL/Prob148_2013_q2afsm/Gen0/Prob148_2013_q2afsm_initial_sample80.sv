module TopModule(
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

reg [1:0] current_state;
reg [1:0] next_state;

// State table
always @(*)
begin
    case (current_state)
        2'b00: // State A
            begin
                if (r[0])
                    next_state = 2'b01; // State B
                else if (r[1])
                    next_state = 2'b10; // State C
                else if (r[2])
                    next_state = 2'b00; // State A (no other requests)
                else
                    next_state = 2'b00; // State A (no requests)
            end
        2'b01: // State B
            begin
                if (r[0])
                    next_state = 2'b01; // State B
                else
                    next_state = 2'b00; // State A
            end
        2'b10: // State C
            begin
                if (r[1])
                    next_state = 2'b10; // State C
                else
                    next_state = 2'b00; // State A
            end
        default:
            next_state = 2'b00; // State A (no other valid states)
    endcase
end

// State flip-flops
always @(posedge clk)
begin
    if (!resetn)
        current_state <= 2'b00; // Reset to State A
    else
        current_state <= next_state;
end

// Output assignments
assign g[0] = (current_state == 2'b01); // State B
assign g[1] = (current_state == 2'b10); // State C
assign g[2] = 1'b0; // No grant in State D (as per problem description)

endmodule