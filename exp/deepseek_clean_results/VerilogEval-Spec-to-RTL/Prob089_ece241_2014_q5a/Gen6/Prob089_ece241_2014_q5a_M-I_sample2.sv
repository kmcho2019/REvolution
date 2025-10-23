module TopModule (
    input clk,
    input areset,
    input x,
    output reg z
);

    reg state; // 0: COPY, 1: INVERT
    reg next_state;
    reg next_z;

    always @(*) begin
        // Next state logic
        next_state = state ? 1'b1 : x;
        
        // Output logic with conditional update
        if (state) begin
            next_z = ~x;
        end else begin
            next_z = x;
        end
    end

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 1'b0;
            z <= 1'b0;
        end else begin
            state <= next_state;
            // Only update z when needed (reduces power)
            if (state != next_state || x != z) begin
                z <= next_z;
            end
        end
    end

endmodule