module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire in,
    output wire out
);

    // State encoding
    localparam A = 1'b0;
    localparam B = 1'b1;

    reg state;

    // Next state combinational logic
    wire next_state = (state == B) ? (in ? B : A) :
                      (state == A) ? (in ? A : B) :
                      B; // default to B

    // State register with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= B;
        else
            state <= next_state;
    end

    // Moore output: depends only on state
    assign out = (state == B) ? 1'b1 : 1'b0;

endmodule