module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    // State register
    reg state;
    localparam A = 1'b0;
    localparam B = 1'b1;

    // Next state logic using continuous assignment
    wire next_state = (state == A) ? (in ? A : B) : (in ? B : A);

    // State register with async reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= B;
        end else begin
            state <= next_state;
        end
    end

    // Output assignment
    assign out = state;

endmodule