module TopModule(
    input clk,
    input areset,
    input in,
    output out
);

    // State encoding
    localparam [1:0]
        A = 2'd0,
        B = 2'd1,
        C = 2'd2,
        D = 2'd3;

    reg [1:0] current_state;

    // Next state logic function
    function [1:0] get_next_state;
        input [1:0] state;
        input in_signal;
        begin
            case (state)
                A: get_next_state = in_signal ? B : A;
                B: get_next_state = in_signal ? B : C;
                C: get_next_state = in_signal ? D : A;
                D: get_next_state = in_signal ? B : C;
                default: get_next_state = A;
            endcase
        end
    endfunction

    wire [1:0] next_state;
    assign next_state = get_next_state(current_state, in);

    // Output combinational logic (Moore)
    assign out = (current_state == D);

    // State register with asynchronous active-high reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            current_state <= A;
        else
            current_state <= next_state;
    end

endmodule