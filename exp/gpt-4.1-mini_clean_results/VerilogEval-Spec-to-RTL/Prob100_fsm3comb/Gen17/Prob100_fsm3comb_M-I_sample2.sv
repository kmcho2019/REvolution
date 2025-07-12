module TopModule (
    input        in,
    input  [1:0] state,
    output reg [1:0] next_state,
    output       out
);

    localparam A = 2'b00, B = 2'b01, C = 2'b10, D = 2'b11;

    always @(*) begin
        // Use blocking assignments for combinational logic
        next_state = (state == A) ? (in ? B : A) :
                     (state == B) ? (in ? B : C) :
                     (state == C) ? (in ? D : A) :
                     (state == D) ? (in ? B : C) :
                     A;  // Default state
    end

    assign out = (state == D);

endmodule