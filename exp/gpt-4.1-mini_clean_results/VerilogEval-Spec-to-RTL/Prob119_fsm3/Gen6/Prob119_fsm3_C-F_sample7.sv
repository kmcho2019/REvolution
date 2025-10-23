module TopModule(
    input  wire clk,
    input  wire areset,
    input  wire in,
    output wire out
);

    // State encoding using localparam for clarity and synthesis compatibility
    localparam [1:0]
        A = 2'b00,
        B = 2'b01,
        C = 2'b10,
        D = 2'b11;

    reg [1:0] state, next_state;

    // Next state logic function
    function [1:0] next_state_func(input [1:0] curr_state, input in_signal);
        begin
            case (curr_state)
                A: next_state_func = (in_signal) ? B : A;
                B: next_state_func = (in_signal) ? B : C;
                C: next_state_func = (in_signal) ? D : A;
                D: next_state_func = (in_signal) ? B : C;
                default: next_state_func = A;
            endcase
        end
    endfunction

    // Next state combinational logic using the function
    always @(*) begin
        next_state = next_state_func(state, in);
    end

    // State register with asynchronous active-high reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= A;
        else
            state <= next_state;
    end

    // Moore output logic as a continuous assignment based solely on current state
    assign out = (state == D);

endmodule