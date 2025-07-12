module signal_generator (
    input             clk,
    input             rst_n,
    output reg [4:0]  wave
);

    reg state;  // 0: increment, 1: decrement

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            wave  <= 5'd0;
            state <= 1'b0;  // start incrementing
        end else begin
            // Update wave based on state (direction)
            case (state)
                1'b0: wave <= wave + 5'd1; // increment
                1'b1: wave <= wave - 5'd1; // decrement
            endcase

            // Toggle state at boundaries to reverse direction
            if ((state == 1'b0 && wave == 5'd31) || (state == 1'b1 && wave == 5'd0))
                state <= ~state;
        end
    end

endmodule