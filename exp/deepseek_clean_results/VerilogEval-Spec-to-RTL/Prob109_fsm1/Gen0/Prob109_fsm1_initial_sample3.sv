module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    // Define states
    reg state;
    localparam A = 1'b0;
    localparam B = 1'b1;

    // State transition and output logic
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

    // Output is directly the state (Moore machine)
    assign out = state;

endmodule