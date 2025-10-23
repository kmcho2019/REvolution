module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire in,
    output wire out
);

    reg state;

    wire next_state = state ? in : ~in;

    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b1;  // B state
        else
            state <= next_state;
    end

    assign out = state;

endmodule