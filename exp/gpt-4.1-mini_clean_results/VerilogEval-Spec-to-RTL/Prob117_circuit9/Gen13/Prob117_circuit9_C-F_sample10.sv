module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

// Function to calculate next state
function [2:0] next_state;
    input [2:0] curr_q;
    input a_in;
    begin
        if (a_in) begin
            next_state = 3'd4; // Fixed state when a=1
        end else begin
            // Arithmetic modulo-7 increment for cycling states 0..6
            // If current state >=6 wrap to 0, else curr_q +1
            next_state = (curr_q == 3'd6) ? 3'd0 : (curr_q + 3'd1);
        end
    end
endfunction

wire [2:0] computed_next = next_state(q, a);

always @(posedge clk) begin
    if (q != computed_next) begin
        q <= computed_next;
    end
    // Else hold q stable to reduce switching and power
end

endmodule