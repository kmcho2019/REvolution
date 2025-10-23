module TopModule(
    input  wire clk,
    input  wire areset,
    input  wire in,
    output wire out
);

    // State encoding
    localparam [1:0] A = 2'd0,
                     B = 2'd1,
                     C = 2'd2,
                     D = 2'd3;

    reg [1:0] state, next_state;

    // Next state combinational logic
    always @(*) begin
        case (state)
            A: next_state = in ? B : A;
            B: next_state = in ? B : C;
            C: next_state = in ? D : A;
            D: next_state = in ? B : C;
            default: next_state = A;
        endcase
    end

    // State register with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= A;
        else
            state <= next_state;
    end

    // Moore output depends only on state D
    assign out = (state == D);

endmodule