module TopModule (
    input  clk,
    input  reset,
    input  in,
    output out
);

    // State encoding as parameters
    localparam A = 2'b00;
    localparam B = 2'b01;
    localparam C = 2'b10;
    localparam D = 2'b11;

    reg [1:0] state;

    wire [1:0] next_state;

    // Combinational next state logic as continuous assignment
    assign next_state = (state == A) ? ((in == 1'b0) ? A : B) :
                        (state == B) ? ((in == 1'b0) ? C : B) :
                        (state == C) ? ((in == 1'b0) ? A : D) :
                        (state == D) ? ((in == 1'b0) ? C : B) :
                        A; // default fallback

    // Moore output: high only in state D
    assign out = (state == D) ? 1'b1 : 1'b0;

    // Sequential state register update with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

endmodule