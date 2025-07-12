module TopModule (
    input  clk,
    input  reset,
    input  in,
    output out
);

    // State encoding
    localparam [1:0]
        A = 2'b00,
        B = 2'b01,
        C = 2'b10,
        D = 2'b11;

    reg [1:0] state;

    // Next state combinational logic encapsulated in a function for clarity
    function [1:0] next_state_func;
        input [1:0] curr_state;
        input       in_sig;
        begin
            case (curr_state)
                A: next_state_func = in_sig ? B : A;
                B: next_state_func = in_sig ? B : C;
                C: next_state_func = in_sig ? D : A;
                D: next_state_func = in_sig ? B : C;
                default: next_state_func = A; // safe default
            endcase
        end
    endfunction

    wire [1:0] next_state = next_state_func(state, in);

    // Sequential state register with synchronous active-high reset
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

    // Moore output logic: combinational and depends only on current state
    assign out = (state == D);

endmodule