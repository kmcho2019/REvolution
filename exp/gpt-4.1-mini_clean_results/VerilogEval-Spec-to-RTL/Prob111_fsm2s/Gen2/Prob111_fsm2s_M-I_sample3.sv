module TopModule(
    input clk,
    input reset,
    input j,
    input k,
    output reg out
);

    reg state, next_state; // 0=OFF, 1=ON

    always @(*) begin
        // Next state logic and output combined in one block for optimization
        if (state == 1'b0) begin // OFF state
            if (j)
                next_state = 1'b1; // ON
            else
                next_state = 1'b0; // OFF
            out = 1'b0; // output in OFF state
        end else begin // ON state
            if (k)
                next_state = 1'b0; // OFF
            else
                next_state = 1'b1; // ON
            out = 1'b1; // output in ON state
        end
    end

    always @(posedge clk) begin
        if (reset)
            state <= 1'b0; // OFF
        else
            state <= next_state;
    end

endmodule