module TopModule(
    input clk,
    input reset,
    input in,
    output out
);

    // State encoding
    localparam B = 1'b0;
    localparam A = 1'b1;

    reg state, next_state;

    // State register with synchronous active-high reset
    always @(posedge clk) begin
        if (reset)
            state <= B;
        else
            state <= next_state;
    end

    // Next state logic
    always @(*) begin
        if (state == B) begin
            if (in == 1'b0)
                next_state = A;
            else
                next_state = B;
        end else begin // state == A
            if (in == 1'b0)
                next_state = B;
            else
                next_state = A;
        end
    end

    // Output logic: Moore output depends only on current state
    assign out = ~state;  // B=0 => out=1; A=1 => out=0

endmodule