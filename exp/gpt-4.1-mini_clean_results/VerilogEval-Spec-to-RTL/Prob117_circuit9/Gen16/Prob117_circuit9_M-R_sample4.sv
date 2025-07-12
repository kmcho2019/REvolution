module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

localparam [2:0]
    S0 = 3'd0,
    S1 = 3'd1,
    S2 = 3'd2,
    S3 = 3'd3,
    S4 = 3'd4,
    S5 = 3'd5,
    S6 = 3'd6;

// Function to determine next state
function [2:0] get_next_state(input [2:0] state, input a_in);
    begin
        if (a_in)
            get_next_state = S4;
        else begin
            case (state)
                S4: get_next_state = S5;
                S5: get_next_state = S6;
                S6: get_next_state = S0;
                S0: get_next_state = S1;
                S1: get_next_state = S2;
                S2: get_next_state = S3;
                S3: get_next_state = S4;
                default: get_next_state = S4;
            endcase
        end
    end
endfunction

always @(posedge clk) begin
    q <= get_next_state(q, a);
end

endmodule