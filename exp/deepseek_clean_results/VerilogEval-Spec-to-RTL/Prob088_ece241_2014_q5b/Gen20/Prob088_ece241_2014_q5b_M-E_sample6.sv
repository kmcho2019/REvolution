module TopModule (
    input clk,
    input areset,
    input x,
    output reg z
);

    reg state;  // 0=A, 1=B
    wire next_state;
    wire next_z;

    // Combined state transition and output logic
    assign next_state = (state == 0) ? x : 1'b1;
    assign next_z = (state == 0) ? x : ~x;

    // State register with async reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 1'b0;  // Reset to state A
            z <= 1'b0;
        end else begin
            state <= next_state;
            z <= next_z;
        end
    end

endmodule