module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    // State register with localparam definitions
    reg state;
    localparam A = 1'b0;
    localparam B = 1'b1;

    // Combined state transition and register update
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= B;  // Async reset to state B
        end else begin
            case (state)
                A: state <= in ? A : B;
                B: state <= in ? B : A;
            endcase
        end
    end

    // Output assignment (Moore machine)
    assign out = state;

endmodule