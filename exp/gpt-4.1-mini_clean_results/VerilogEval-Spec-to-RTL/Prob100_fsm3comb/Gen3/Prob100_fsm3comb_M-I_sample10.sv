module TopModule(
    input       in,
    input [1:0] state,
    output reg [1:0] next_state,
    output          out
);

    localparam A = 2'b00;
    localparam B = 2'b01;
    localparam C = 2'b10;
    localparam D = 2'b11;

    assign out = (state == D) ? 1'b1 : 1'b0;

    always @(*) begin
        next_state = (state == A) ? ((in == 1'b0) ? A : B) :
                     (state == B) ? ((in == 1'b0) ? C : B) :
                     (state == C) ? ((in == 1'b0) ? A : D) :
                     (state == D) ? ((in == 1'b0) ? C : B) :
                     A;
    end

endmodule