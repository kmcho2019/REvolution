module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    // One-hot state encoding
    reg [3:0] state;
    localparam A = 4'b0001;
    localparam B = 4'b0010;
    localparam C = 4'b0100;
    localparam D = 4'b1000;

    // State transition logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= A;
        end else begin
            state[0] <= (state[0] & ~in) | (state[2] & ~in);  // A or C->A
            state[1] <= (state[0] & in) | (state[1] & in) | (state[3] & in);  // A->B or B or D->B
            state[2] <= (state[1] & ~in) | (state[3] & ~in);  // B->C or D->C
            state[3] <= (state[2] & in);  // C->D
        end
    end

    // Output is just the D state bit
    assign out = state[3];

endmodule