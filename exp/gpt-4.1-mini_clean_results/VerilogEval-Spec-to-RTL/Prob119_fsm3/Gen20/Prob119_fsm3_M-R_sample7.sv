module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
);

    localparam [1:0] A=2'd0, B=2'd1, C=2'd2, D=2'd3;
    reg [1:0] state;
    reg [1:0] next_state;
    wire out;

    // Next state combinational logic
    always @(*) begin
        case(state)
            A: next_state = in ? B : A;
            B: next_state = in ? B : C;
            C: next_state = in ? D : A;
            D: next_state = in ? B : C;
            default: next_state = A;
        endcase
    end

    // State register with async reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= A;
        else
            state <= next_state;
    end

    // Output combinational logic assigned by continuous assignment
    assign out = (state == D);

endmodule