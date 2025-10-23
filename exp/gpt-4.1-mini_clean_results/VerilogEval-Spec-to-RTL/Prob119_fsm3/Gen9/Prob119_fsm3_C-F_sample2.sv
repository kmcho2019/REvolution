module TopModule (
    input  clk,
    input  areset,
    input  in,
    output out
);

    // State encoding with localparam for synthesis clarity
    localparam [1:0]
        A = 2'd0,
        B = 2'd1,
        C = 2'd2,
        D = 2'd3;

    reg [1:0] current_state;

    // Next state combinational logic as a wire using case expression
    wire [1:0] next_state = (current_state == A) ? (in ? B : A) :
                            (current_state == B) ? (in ? B : C) :
                            (current_state == C) ? (in ? D : A) :
                            (current_state == D) ? (in ? B : C) :
                            A;  // Default safe fallback

    // State register with asynchronous active-high reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            current_state <= A;
        else
            current_state <= next_state;
    end

    // Moore output logic as continuous assign
    assign out = (current_state == D);

endmodule