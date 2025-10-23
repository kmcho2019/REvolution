module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire in,
    output reg  out
);

    reg state; // 1 = B, 0 = A

    // State register with async reset and clear next state logic in sequential block
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 1'b1;  // Reset to state B
        end else begin
            if (state == 1'b1) begin  // State B
                if (in == 1'b0)
                    state <= 1'b0;    // B->A on 0
                else
                    state <= 1'b1;    // B->B on 1
            end else begin           // State A
                if (in == 1'b0)
                    state <= 1'b1;    // A->B on 0
                else
                    state <= 1'b0;    // A->A on 1
            end
        end
    end

    // Output depends only on current state (Moore machine)
    always @(*) begin
        out = state;  // out=1 for B, 0 for A
    end

endmodule