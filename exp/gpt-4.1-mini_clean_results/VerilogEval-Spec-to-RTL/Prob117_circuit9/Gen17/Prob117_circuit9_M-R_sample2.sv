module TopModule (
    input        clk,
    input        a,
    output reg [2:0] q
);

wire [2:0] next_state;

function [2:0] modulo7_increment;
    input [2:0] val;
    begin
        modulo7_increment = (val == 3'd6) ? 3'd0 : val + 3'd1;
    end
endfunction

assign next_state = a ? 3'd4 : modulo7_increment(q);

always @(posedge clk) begin
    q <= next_state;
end

endmodule