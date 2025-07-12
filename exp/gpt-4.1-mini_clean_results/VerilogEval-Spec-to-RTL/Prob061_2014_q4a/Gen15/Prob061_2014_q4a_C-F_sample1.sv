module TopModule (
    input  wire clk,
    input  wire w,
    input  wire R,
    input  wire E,
    input  wire L,
    output reg  Q
);

    reg next_Q;

    // Combinational logic to determine the next value of Q
    always @(*) begin
        if (L)
            next_Q = R;      // Load has highest priority
        else if (E)
            next_Q = w;      // Shift on enable
        else
            next_Q = Q;      // Hold current value
    end

    // Sequential logic to update Q on the rising edge of clk
    always @(posedge clk) begin
        Q <= next_Q;
    end

endmodule