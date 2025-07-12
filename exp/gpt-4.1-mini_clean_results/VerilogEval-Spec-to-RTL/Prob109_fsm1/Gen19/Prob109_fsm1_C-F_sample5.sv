module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire in,
    output wire out
);

    // State encoding
    localparam A = 1'b0;
    localparam B = 1'b1;

    reg state, next_state;

    // Next state logic: simplified if-else for synthesis clarity
    always @(*) begin
        if (state == B) begin
            if (in)
                next_state = B;
            else
                next_state = A;
        end else begin // state == A
            if (in)
                next_state = A;
            else
                next_state = B;
        end
    end

    // State register with asynchronous reset to B
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= B;
        else
            state <= next_state;
    end

    // Moore machine output equals current state
    assign out = state;

endmodule