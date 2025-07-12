module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
);

    // State encoding using parameters
    localparam [1:0]
        A = 2'b00,
        B = 2'b01,
        C = 2'b10,
        D = 2'b11;

    reg [1:0] state;

    // Next state logic as combinational function of state and input
    wire [1:0] next_state = (state == A) ? (in ? B : A) :
                           (state == B) ? (in ? B : C) :
                           (state == C) ? (in ? D : A) :
                           (state == D) ? (in ? B : C) :
                           A;  // default fallback

    // Output logic depends only on state (Moore)
    wire out_sig = (state == D) ? 1'b1 : 1'b0;

    // State register with async positive edge reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= A;
        else
            state <= next_state;
    end

    assign out = out_sig;

endmodule