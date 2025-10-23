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

    reg [1:0] current_state, next_state;

    // Next state logic combinational using assign
    wire [1:0] next_state_w;
    assign next_state_w =
        (current_state == A) ? (in ? B : A) :
        (current_state == B) ? (in ? B : C) :
        (current_state == C) ? (in ? D : A) :
        (current_state == D) ? (in ? B : C) :
        A;

    // Output logic combinational using assign (Moore output)
    assign out = (current_state == D);

    // Sequential logic: state update with async reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            current_state <= A;
        else
            current_state <= next_state_w;
    end

endmodule