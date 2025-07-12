module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // Define states using one-hot (though only 2 states)
    reg state;
    localparam B = 1'b0;
    localparam A = 1'b1;

    // Combined state transition and output logic
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

    // Simplified output logic
    assign out = ~state;  // Equivalent to (state == B)

endmodule