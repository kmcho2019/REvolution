module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    localparam B = 1'b0, A = 1'b1;

    reg state;

    wire next_state = (state == B) ? (in ? B : A) : (in ? A : B);

    always @(posedge clk) begin
        if (reset)
            state <= B;
        else if (state != next_state)
            state <= next_state;
    end

    assign out = (state == B);

endmodule