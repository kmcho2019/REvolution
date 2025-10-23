module TopModule(
    input clk,
    input reset,
    input x,
    output z
);
    reg [2:0] y;

    // Function to determine next state based on current state and input x
    function [2:0] next_state;
        input [2:0] state;
        input       x_in;
        begin
            case(state)
                3'b000: next_state = x_in ? 3'b001 : 3'b000;
                3'b001: next_state = x_in ? 3'b100 : 3'b001;
                3'b010: next_state = x_in ? 3'b001 : 3'b010;
                3'b011: next_state = x_in ? 3'b010 : 3'b001;
                3'b100: next_state = x_in ? 3'b100 : 3'b011;
                default: next_state = 3'b000;
            endcase
        end
    endfunction

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            y <= 3'b000;
        else
            y <= next_state(y, x);
    end

    // Output combinational logic: z is high when state is 011 or 100
    assign z = (y == 3'b011) || (y == 3'b100);

endmodule