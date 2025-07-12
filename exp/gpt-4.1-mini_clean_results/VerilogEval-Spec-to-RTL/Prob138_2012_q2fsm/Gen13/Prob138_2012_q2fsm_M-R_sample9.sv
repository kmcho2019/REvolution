module TopModule (
    input  clk,
    input  reset,
    input  w,
    output z
);

    // State encoding (3-bit binary)
    localparam [2:0]
        A = 3'd0,
        B = 3'd1,
        C = 3'd2,
        D = 3'd3,
        E = 3'd4,
        F = 3'd5;

    reg [2:0] state;

    // Next state combinational logic as a combinational function-like assign
    wire [2:0] next_state;
    assign next_state = (state == A) ? (w ? B : A) :
                        (state == B) ? (w ? C : D) :
                        (state == C) ? (w ? E : D) :
                        (state == D) ? (w ? F : A) :
                        (state == E) ? (w ? E : D) :
                        (state == F) ? (w ? C : D) :
                        A;

    // State register with synchronous active-high reset
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

    // Output logic as continuous assignment
    assign z = (state == E) || (state == F);

endmodule