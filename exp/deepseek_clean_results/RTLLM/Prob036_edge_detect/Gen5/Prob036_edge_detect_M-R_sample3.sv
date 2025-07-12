module edge_detect (
    input clk,
    input rst_n,
    input a,
    output rise,
    output down
);

    // State definition
    reg state;  // 0: a was 0, 1: a was 1

    // State transition logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= 1'b0;
        end
        else begin
            state <= a;
        end
    end

    // Output logic - combinational
    assign rise = (a & ~state);  // 0->1 transition
    assign down = (~a & state);  // 1->0 transition

endmodule