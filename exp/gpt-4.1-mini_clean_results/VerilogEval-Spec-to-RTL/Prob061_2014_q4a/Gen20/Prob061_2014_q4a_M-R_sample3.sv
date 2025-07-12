module TopModule (
    input  wire clk,
    input  wire w,
    input  wire R,
    input  wire E,
    input  wire L,
    output reg  Q
);

    reg next_Q;

    // Combinational logic to select next state
    always @(*) begin
        if (L)
            next_Q = R;
        else if (E)
            next_Q = w;
        else
            next_Q = Q; // Hold current state
    end

    // Sequential logic to update Q on clock edge
    always @(posedge clk) begin
        Q <= next_Q;
    end

endmodule