module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

// Function to compute next state based on current q and input a
function [2:0] next_state;
    input [2:0] curr_q;
    input       a_in;
    begin
        if (a_in)
            next_state = 3'd4;
        else begin
            case (curr_q)
                3'd4: next_state = 3'd5;
                3'd5: next_state = 3'd6;
                3'd6: next_state = 3'd0;
                3'd0: next_state = 3'd1;
                3'd1: next_state = 3'd2;
                3'd2: next_state = 3'd3;
                3'd3: next_state = 3'd4;
                default: next_state = 3'd4;
            endcase
        end
    end
endfunction

reg [2:0] next_q;

always @(*) begin
    next_q = next_state(q, a);
end

always @(posedge clk) begin
    q <= next_q;
end

endmodule