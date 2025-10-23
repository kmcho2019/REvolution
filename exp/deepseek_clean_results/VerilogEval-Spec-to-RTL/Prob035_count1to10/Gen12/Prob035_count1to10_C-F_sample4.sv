module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

parameter START = 4'b0001;  // Starting value (1)
parameter END   = 4'b1010;  // Ending value (10)

// Efficient next state calculation
function [3:0] get_next_state;
    input [3:0] current;
    begin
        // Optimized detection for END value (10 = 1010)
        if (current[3] & current[1])
            get_next_state = START;
        else
            get_next_state = current + 1;
    end
endfunction

always @(posedge clk) begin
    if (reset)
        q <= START;         // Synchronous reset to START value
    else
        q <= get_next_state(q);  // Use function for next state
end

endmodule