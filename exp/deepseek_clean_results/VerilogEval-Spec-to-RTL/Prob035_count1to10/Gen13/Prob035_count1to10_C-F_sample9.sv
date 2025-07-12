module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

// Counter parameters
parameter START = 4'b0001;  // Starting value (1)
parameter END   = 4'b1010;  // Ending value (10)

// Efficient next state calculation function
function [3:0] next_state;
    input [3:0] current;
    begin
        // Optimized detection for END value (10 = 1010)
        next_state = (current[3] & current[1]) ? START : current + 1;
    end
endfunction

// Continuous assignment for combinational logic
wire [3:0] next_q = reset ? START : next_state(q);

// Minimal sequential block
always @(posedge clk) begin
    q <= next_q;
end

endmodule