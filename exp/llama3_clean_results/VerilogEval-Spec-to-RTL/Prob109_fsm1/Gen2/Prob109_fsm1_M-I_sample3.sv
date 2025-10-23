module TopModule(
    input clk,
    input areset,
    input in,
    output out
);

    // Define states
    reg state;
    parameter B = 1'b1;
    parameter A = 1'b0;

    // Next state logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= B;
        end else begin
            if (state == B) begin
                state <= (in == 1'b0) ? A : B;
            end else if (state == A) begin
                state <= (in == 1'b0) ? B : A;
            end
        end
    end

    // Output logic
    assign out = (state == B) ? 1'b1 : 1'b0;

endmodule