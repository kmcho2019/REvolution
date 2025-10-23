module TopModule (
    input  clk,
    input  reset,
    input  in,
    output reg out
);

    // State encoding
    localparam [1:0]
        A = 2'b00,
        B = 2'b01,
        C = 2'b10,
        D = 2'b11;

    reg [1:0] state, next_state;

    // Next state combinational logic using always_comb style block
    always @(*) begin
        case (state)
            A: next_state = in ? B : A;
            B: next_state = in ? B : C;
            C: next_state = in ? D : A;
            D: next_state = in ? B : C;
            default: next_state = A;
        endcase
    end

    // State register with synchronous active-high reset
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

    // Registered Moore output to reduce glitches
    always @(posedge clk) begin
        if (reset)
            out <= 1'b0;
        else
            out <= (state == D);
    end

endmodule