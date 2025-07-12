module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

    // State encoding
    localparam [1:0]
        A = 2'b00,
        B = 2'b01,
        C = 2'b10,
        D = 2'b11;

    reg [1:0] state;

    wire [1:0] next_state;

    // Next-state logic using continuous assignments with priority encoding
    assign next_state = (state == A) ?
                        (r[0] ? B :
                         r[1] ? C :
                         r[2] ? D : A) :
                        (state == B) ? (r[0] ? B : A) :
                        (state == C) ? (r[1] ? C : A) :
                        (state == D) ? (r[2] ? D : A) : A;

    // Output logic assigned combinationally from state
    assign g = (state == B) ? 3'b001 :
               (state == C) ? 3'b010 :
               (state == D) ? 3'b100 :
               3'b000;

    // State flip-flops with synchronous active-low reset
    always @(posedge clk) begin
        if (~resetn)
            state <= A;
        else
            state <= next_state;
    end

endmodule