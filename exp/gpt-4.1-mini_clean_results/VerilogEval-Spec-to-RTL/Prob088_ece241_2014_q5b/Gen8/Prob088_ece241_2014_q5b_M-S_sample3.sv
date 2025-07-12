module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output wire z
);

    // One-hot encoded states
    localparam [1:0] A = 2'b01;
    localparam [1:0] B = 2'b10;

    reg [1:0] state, next_state;

    // Next state logic
    always @(*) begin
        if (state == A)
            next_state = x ? B : A;
        else // state == B
            next_state = B;
    end

    // State register with asynchronous active-high reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= A;
        else
            state <= next_state;
    end

    // Output logic (Mealy): z=1 if (A and x=1) or (B and x=0)
    assign z = (state == A) ? x : ~x;

endmodule