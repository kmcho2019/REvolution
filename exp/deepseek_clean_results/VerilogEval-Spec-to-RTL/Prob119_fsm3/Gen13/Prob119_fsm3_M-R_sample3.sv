module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    // One-hot state encoding
    parameter A = 4'b0001;
    parameter B = 4'b0010;
    parameter C = 4'b0100;
    parameter D = 4'b1000;

    reg [3:0] state;

    // Next state logic using continuous assignments
    wire next_A = (state == A) & ~in | (state == C) & ~in;
    wire next_B = (state == A) & in | (state == B) & in | (state == D) & in;
    wire next_C = (state == B) & ~in | (state == D) & ~in;
    wire next_D = (state == C) & in;

    // State register with async reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= A;
        end else begin
            state <= {next_D, next_C, next_B, next_A};
        end
    end

    // Output logic
    assign out = (state == D);

endmodule