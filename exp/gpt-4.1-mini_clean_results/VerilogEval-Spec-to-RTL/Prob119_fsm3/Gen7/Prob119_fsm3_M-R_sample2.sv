module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
);

    // State encoding
    parameter A = 2'b00,
              B = 2'b01,
              C = 2'b10,
              D = 2'b11;

    reg [1:0] state;

    // Asynchronous reset, synchronous state update
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= A;
        else
            state <= next_state;
    end

    // Next state logic implemented with assign
    wire [1:0] next_state;
    assign next_state =
        (state == A) ? (in ? B : A) :
        (state == B) ? (in ? B : C) :
        (state == C) ? (in ? D : A) :
        (state == D) ? (in ? B : C) :
        A;  // Default safe state

    // Moore output logic as a simple assign
    assign out = (state == D) ? 1'b1 : 1'b0;

endmodule