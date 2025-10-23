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

    // Combined sequential and combinational logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= B;  // Async reset to state B
        end else begin
            state <= (state == A) ? (in ? A : B) : (in ? B : A);
        end
    end

    // Output assignment (Moore machine)
    assign out = state;

endmodule