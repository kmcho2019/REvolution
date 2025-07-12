module TopModule (
    input        clk,
    input        areset,
    input        train_valid,
    input        train_taken,
    output reg [1:0] state
);

    reg [2:0] next_state; // 3 bits to prevent overflow during arithmetic

    always @* begin
        // Default delta is 0 (no change)
        integer delta;
        delta = 0;
        if (train_valid) begin
            delta = train_taken ? 1 : -1;
        end

        // Compute tentative next state with saturation
        integer temp;
        temp = state + delta;
        if (temp < 0)
            next_state = 0;
        else if (temp > 3)
            next_state = 3;
        else
            next_state = temp[1:0];
    end

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 2'b01;  // weakly not-taken reset state
        end else begin
            state <= next_state[1:0];
        end
    end

endmodule