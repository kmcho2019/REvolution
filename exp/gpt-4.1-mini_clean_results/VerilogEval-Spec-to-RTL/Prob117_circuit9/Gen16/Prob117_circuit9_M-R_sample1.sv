module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

// Function to calculate next state based on current state and input a
function [2:0] next_state_func;
    input [2:0] current_state;
    input a_in;
    begin
        if (a_in) begin
            next_state_func = 3'd4;
        end else begin
            case (current_state)
                3'd4: next_state_func = 3'd5;
                3'd5: next_state_func = 3'd6;
                3'd6: next_state_func = 3'd0;
                3'd0: next_state_func = 3'd1;
                3'd1: next_state_func = 3'd2;
                3'd2: next_state_func = 3'd3;
                3'd3: next_state_func = 3'd4;
                default: next_state_func = 3'd4;
            endcase
        end
    end
endfunction

always @(posedge clk) begin
    q <= next_state_func(q, a);
end

endmodule