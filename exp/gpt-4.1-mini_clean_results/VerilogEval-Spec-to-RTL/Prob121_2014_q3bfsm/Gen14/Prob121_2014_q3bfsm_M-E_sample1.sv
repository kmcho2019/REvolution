module TopModule (
    input  clk,
    input  reset,
    input  x,
    output reg z
);

    reg [2:0] state;

    // Function to determine the next state
    function [2:0] next_state_func;
        input [2:0] curr_state;
        input       in_x;
        begin
            case (curr_state)
                3'b000: next_state_func = in_x ? 3'b001 : 3'b000;
                3'b001: next_state_func = in_x ? 3'b100 : 3'b001;
                3'b010: next_state_func = in_x ? 3'b001 : 3'b010;
                3'b011: next_state_func = in_x ? 3'b010 : 3'b001;
                3'b100: next_state_func = in_x ? 3'b100 : 3'b011;
                default: next_state_func = 3'b000;
            endcase
        end
    endfunction

    // Sequential block: update state and output together
    always @(posedge clk) begin
        if (reset) begin
            state <= 3'b000;
            z <= 1'b0;
        end else begin
            state <= next_state_func(state, x);
            // Output z = 1 only in states 011 or 100
            z <= (state == 3'b011) || (state == 3'b100);
        end
    end

endmodule