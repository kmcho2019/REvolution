module TopModule (
    input        clk,
    input        reset,
    input        in,
    output       out
);

    // State encoding
    localparam [1:0]
        A = 2'b00,
        B = 2'b01,
        C = 2'b10,
        D = 2'b11;

    reg [1:0] state, next_state;

    // Sequential state update with synchronous reset and combined next-state logic
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else begin
            case (state)
                A: next_state = in ? B : A;
                B: next_state = in ? B : C;
                C: next_state = in ? D : A;
                D: next_state = in ? B : C;
                default: next_state = A;
            endcase
            state <= next_state;
        end
    end

    // Moore output depends only on state
    assign out = (state == D);

endmodule