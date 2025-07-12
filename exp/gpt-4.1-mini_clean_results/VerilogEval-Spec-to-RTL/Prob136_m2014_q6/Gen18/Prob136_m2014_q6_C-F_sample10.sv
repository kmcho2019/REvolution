module TopModule (
    input  clk,
    input  reset,
    input  w,
    output z
);

    // State encoding
    localparam [2:0]
        A = 3'd0,
        B = 3'd1,
        C = 3'd2,
        D = 3'd3,
        E = 3'd4,
        F = 3'd5;

    reg [2:0] state;
    wire [2:0] next_state;

    // Next state combinational logic using continuous assignment and nested ternaries
    assign next_state = (state == A) ? (w ? A : B) :
                        (state == B) ? (w ? D : C) :
                        (state == C) ? (w ? D : E) :
                        (state == D) ? (w ? A : F) :
                        (state == E) ? (w ? D : E) :
                        (state == F) ? (w ? D : C) :
                        A;  // default fallback to A

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

    // Output logic: z=1 if state is E or F
    assign z = (state == E) || (state == F);

endmodule