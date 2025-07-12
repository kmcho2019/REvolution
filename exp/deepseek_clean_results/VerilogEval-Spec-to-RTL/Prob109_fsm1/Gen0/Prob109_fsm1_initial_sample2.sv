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

    // State transition logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= B;
        end else begin
            case (state)
                A: state <= in ? A : B;
                B: state <= in ? B : A;
            endcase
        end
    end

    // Output logic (Moore machine: output depends only on state)
    assign out = state;

endmodule