module TopModule (
    input clk,
    input reset,
    input x,
    output reg z
);

    reg [2:0] state;

    // Function to determine the next state based on current state and input x
    function [2:0] next_state_func;
        input [2:0] curr_state;
        input       x_in;
        begin
            case (curr_state)
                3'b000: next_state_func = x_in ? 3'b001 : 3'b000;
                3'b001: next_state_func = x_in ? 3'b100 : 3'b001;
                3'b010: next_state_func = x_in ? 3'b001 : 3'b010;
                3'b011: next_state_func = x_in ? 3'b010 : 3'b001;
                3'b100: next_state_func = x_in ? 3'b100 : 3'b011;
                default: next_state_func = 3'b000; // safe fallback
            endcase
        end
    endfunction

    // Sequential block: synchronous reset and state update
    always @(posedge clk) begin
        if (reset)
            state <= 3'b000;
        else
            state <= next_state_func(state, x);
    end

    // Combinational logic: output z as function of current state bits
    // z=1 when state=3'b011 or 3'b100
    always @(*) begin
        // The output is 1 if state is 011 or 100
        z = (state == 3'b011) || (state == 3'b100);
    end

endmodule