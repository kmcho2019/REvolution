module TopModule(
    input clk,
    input reset,
    input j,
    input k,
    output reg out
);

    reg state, next_state; // 0=OFF, 1=ON

    always @(*) begin
        if (state == 1'b0) begin // OFF state
            if (j)
                next_state = 1'b1; // ON
            else
                next_state = 1'b0; // OFF
        end else begin // ON state
            if (k)
                next_state = 1'b0; // OFF
            else
                next_state = 1'b1; // ON
        end
    end

    always @(posedge clk) begin
        if (reset)
            state <= 1'b0; // OFF
        else
            state <= next_state;
    end

    always @(*) begin
        out = state; // out=0 in OFF, 1 in ON
    end

endmodule