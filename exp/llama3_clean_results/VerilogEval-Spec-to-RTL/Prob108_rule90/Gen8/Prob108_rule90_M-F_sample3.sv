module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);

reg [511:0] q_reg;

// Calculate next state for each cell using combinational logic
assign q = (load)? data : calculate_next_state(q_reg);

// Combinational logic to calculate next state
function [511:0] calculate_next_state;
    input [511:0] current_state;
    reg [511:0] next_state;
    
    // Calculate next state for each cell
    for (int i = 0; i < 512; i++) begin
        if (i == 0) begin
            // Left boundary condition: left neighbor is 0
            next_state[i] = 1'b0 ^ current_state[1];
        end else if (i == 511) begin
            // Right boundary condition: right neighbor is 0
            next_state[i] = current_state[510] ^ 1'b0;
        end else begin
            // Apply Rule 90: next state is XOR of left and right neighbors
            next_state[i] = current_state[i-1] ^ current_state[i+1];
        end
    end
    
    calculate_next_state = next_state;
endfunction

always @(posedge clk) begin
    if (load) begin
        q_reg <= data;
    end else begin
        q_reg <= q;
    end
end

endmodule