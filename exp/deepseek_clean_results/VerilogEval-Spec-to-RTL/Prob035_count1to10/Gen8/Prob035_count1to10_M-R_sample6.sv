module TopModule (
    input clk,
    input reset,
    output [3:0] q
);

function [3:0] next_state;
    input [3:0] current;
    input reset;
    begin
        if (reset)
            next_state = 4'b0001;
        else if (current[3] & current[1]) // Detect 10 (1010)
            next_state = 4'b0001;
        else
            next_state = current + 1;
    end
endfunction

reg [3:0] q_reg;
wire [3:0] next_q = next_state(q_reg, reset);

always @(posedge clk) begin
    q_reg <= next_q;
end

assign q = q_reg;

endmodule