module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // Define states
    reg state;
    localparam B = 1'b1;
    localparam A = 1'b0;

    // State transition and output logic
    always @(posedge clk) begin
        if (reset) begin
            state <= B;
        end else begin
            case (state)
                B: state <= in ? B : A;
                A: state <= in ? A : B;
            endcase
        end
    end

    // Output depends only on current state (Moore machine)
    assign out = (state == B) ? 1'b1 : 1'b0;

endmodule