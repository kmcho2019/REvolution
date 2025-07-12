module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire in,
    output wire out
);

    // State encoding: A=0, B=1
    localparam A = 1'b0;
    localparam B = 1'b1;

    reg state;
    wire next_state;

    // Combinational next state logic based on current state and input
    assign next_state = (state == B) ? (in ? B : A)
                                     : (in ? A : B);

    // Sequential state register with asynchronous reset to B
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= B;
        else
            state <= next_state;
    end

    // Output equals current state (Moore machine output)
    assign out = state;

endmodule