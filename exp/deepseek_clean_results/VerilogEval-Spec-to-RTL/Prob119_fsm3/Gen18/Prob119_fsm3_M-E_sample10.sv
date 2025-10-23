module TopModule (
    input clk,
    input areset,
    input in,
    output reg out
);

    // One-hot state encoding
    parameter [3:0] A = 4'b0001;
    parameter [3:0] B = 4'b0010;
    parameter [3:0] C = 4'b0100;
    parameter [3:0] D = 4'b1000;

    reg [3:0] state;

    // State transition logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= A;
        end else begin
            state[0] <= (~in & state[0]) | (~in & state[2]);  // A or C->A
            state[1] <= (in & state[0]) | (in & state[1]) | (in & state[3]);  // A->B or B or D->B
            state[2] <= (~in & state[1]) | (~in & state[3]);  // B->C or D->C
            state[3] <= (in & state[2]);  // C->D
        end
    end

    // Output register
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            out <= 1'b0;
        end else begin
            out <= state[3];  // Output is 1 only in state D
        end
    end

endmodule