module TopModule (
    input  clk,
    input  reset,
    input  in,
    output out
);

    // State encoding (binary)
    localparam [1:0]
        A = 2'b00,
        B = 2'b01,
        C = 2'b10,
        D = 2'b11;

    reg [1:0] state;

    // Next state logic as combinational continuous assignment
    wire [1:0] next_state = (state == A) ? (in ? B : A) :
                            (state == B) ? (in ? B : C) :
                            (state == C) ? (in ? D : A) :
                            (state == D) ? (in ? B : C) :
                            A; // Default to A for safety

    // Moore output: output is 1 only in state D
    assign out = (state == D);

    // Sequential state register with synchronous active-high reset
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

endmodule