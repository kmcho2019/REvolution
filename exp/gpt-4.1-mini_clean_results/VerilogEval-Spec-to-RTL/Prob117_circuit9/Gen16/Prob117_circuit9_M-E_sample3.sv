module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

// Function to compute next state based on current state and input a
function [2:0] next_state;
    input [2:0] current;
    input       a_in;
    begin
        if (a_in)
            next_state = 3'd4;  // Force state 4 when a=1
        else begin
            // Cycle through 4->5->6->0->1->2->3->4...
            // If current < 4, then next = current+1 (mod 7), with wrap-around at 3 to 4
            // Else if current >= 4, cycle increment modulo 7 starting at 4
            if (current >= 3'd4)
                next_state = (current == 3'd6) ? 3'd0 : current + 3'd1;
            else
                next_state = (current == 3'd3) ? 3'd4 : current + 3'd1;
        end
    end
endfunction

initial begin
    q = 3'bxxx; // Initial unknown state matching waveform start
end

always @(posedge clk) begin
    q <= next_state(q, a);
end

endmodule