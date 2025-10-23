module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    reg state;  // 0: copying, 1: inverting
    wire next_state;
    wire next_z;

    // State transition logic
    assign next_state = state | x;

    // Output logic
    assign next_z = state ? ~x : x;
    assign z = next_z;

    // State register
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 1'b0;
        end else begin
            state <= next_state;
        end
    end

endmodule