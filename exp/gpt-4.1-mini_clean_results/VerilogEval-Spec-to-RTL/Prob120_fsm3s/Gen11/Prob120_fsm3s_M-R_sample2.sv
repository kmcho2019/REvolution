module TopModule (
    input  clk,
    input  reset,
    input  in,
    output out
);

    // State encoding
    localparam [1:0] A = 2'b00,
                     B = 2'b01,
                     C = 2'b10,
                     D = 2'b11;

    reg [1:0] state, next_state;

    // Next-state logic as a combinational function using assign
    wire [1:0] next_state_w;

    assign next_state_w = (state == A) ? (in ? B : A) :
                          (state == B) ? (in ? B : C) :
                          (state == C) ? (in ? D : A) :
                          (state == D) ? (in ? B : C) : A;

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state_w;
    end

    // Moore output logic derived from current state
    assign out = (state == D) ? 1'b1 : 1'b0;

endmodule