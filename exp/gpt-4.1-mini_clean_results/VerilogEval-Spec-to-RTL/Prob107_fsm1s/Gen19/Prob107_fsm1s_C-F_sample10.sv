module TopModule (
    input  clk,
    input  reset,
    input  in,
    output out
);

    // State encoding
    localparam B = 1'b0;
    localparam A = 1'b1;

    reg state, next_state;

    // Next state combinational logic: simplified with if-else and direct input check
    always @(*) begin
        if (state == B) begin
            if (~in)
                next_state = A;
            else
                next_state = B;
        end else begin // state == A
            if (~in)
                next_state = B;
            else
                next_state = A;
        end
    end

    // State register: synchronous active-high reset
    always @(posedge clk) begin
        if (reset)
            state <= B;
        else
            state <= next_state;
    end

    // Moore output: 1 in state B, else 0
    assign out = (state == B);

endmodule