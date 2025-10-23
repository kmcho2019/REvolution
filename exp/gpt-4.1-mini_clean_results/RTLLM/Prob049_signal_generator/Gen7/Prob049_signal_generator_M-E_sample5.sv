module signal_generator (
    input           clk,
    input           rst_n,
    output reg [4:0] wave
);

    reg dir; // direction: 0 = increment, 1 = decrement

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            wave <= 5'd0;
            dir  <= 1'b0; // start incrementing
        end else begin
            // Check boundary and update direction
            if (wave == 5'd31)
                dir <= 1'b1; // switch to decrement
            else if (wave == 5'd0)
                dir <= 1'b0; // switch to increment
            
            // Update wave based on direction
            if (dir == 1'b0)
                wave <= wave + 1;
            else
                wave <= wave - 1;
        end
    end

endmodule