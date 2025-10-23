module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire in,
    output reg  out
);

    // State encoding
    localparam A = 1'b0;
    localparam B = 1'b1;

    reg state;
    wire next_state;

    // Next state logic using assign
    assign next_state = (state == B) ? (in ? B : A) : (in ? A : B);

    // State register with asynchronous reset to B
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= B;
        else
            state <= next_state;
    end

    // Output register updated synchronously (Moore output)
    always @(posedge clk or posedge areset) begin
        if (areset)
            out <= 1'b1;  // output for state B
        else
            out <= (state == B) ? 1'b1 : 1'b0;
    end

endmodule