module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    // State definitions
    localparam PASS = 1'b0;
    localparam INVERT = 1'b1;

    reg state;

    // State transition logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= PASS;
        end else begin
            case (state)
                PASS: state <= x ? INVERT : PASS;
                INVERT: state <= INVERT;
            endcase
        end
    end

    // Output logic using continuous assignment
    assign z = state ? ~x : x;

endmodule