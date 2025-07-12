module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // Define states
    reg state;
    localparam B = 1'b0;
    localparam A = 1'b1;

    // State transition logic
    always @(posedge clk) begin
        if (reset) begin
            state <= B;
        end else begin
            case (state)
                B: state <= in ? B : A;
                A: state <= in ? A : B;
                default: state <= B;
            endcase
        end
    end

    // Output logic (Moore: output depends only on state)
    assign out = (state == B) ? 1'b1 : 1'b0;

endmodule