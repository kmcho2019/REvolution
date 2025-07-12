module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // State definitions with localparam for readability
    reg state;
    localparam A = 1'b0;
    localparam B = 1'b1;

    // State transition logic
    always @(posedge clk) begin
        if (reset) begin
            state <= B;  // Synchronous reset to state B
        end else begin
            case (state)
                A: state <= in ? A : B;  // A transitions
                B: state <= in ? B : A;  // B transitions
            endcase
        end
    end

    // Output logic - direct state assignment (most efficient)
    assign out = state;  // B=1 (out=1), A=0 (out=0)

endmodule