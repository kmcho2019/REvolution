module TopModule (
    input  clk,
    input  reset,
    input  x,
    output reg z
);

    // State encoding
    localparam S0 = 3'b000,
               S1 = 3'b001,
               S2 = 3'b010,
               S3 = 3'b011,
               S4 = 3'b100;

    reg [2:0] state;

    // Combinational next state function
    function [2:0] next_state_f;
        input [2:0] curr_state;
        input       x_in;
        begin
            case (curr_state)
                S0: next_state_f = x_in ? S1 : S0;
                S1: next_state_f = x_in ? S4 : S1;
                S2: next_state_f = x_in ? S1 : S2;
                S3: next_state_f = x_in ? S2 : S1;
                S4: next_state_f = x_in ? S4 : S3;
                default: next_state_f = S0;
            endcase
        end
    endfunction

    wire [2:0] next_state = next_state_f(state, x);

    // Sequential logic: state update and output registered synchronously
    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            z <= 1'b0;
        end else begin
            state <= next_state;
            // Output z registered based on the present state before the update,
            // or based on next_state if Moore machine style preferred.
            // Here, output based on next_state to reflect output of next state.
            if (next_state == S3 || next_state == S4)
                z <= 1'b1;
            else
                z <= 1'b0;
        end
    end

endmodule