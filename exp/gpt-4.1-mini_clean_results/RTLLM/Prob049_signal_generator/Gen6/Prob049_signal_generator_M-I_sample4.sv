module signal_generator (
    input             clk,
    input             rst_n,
    output reg [4:0]  wave
);

    reg direction; // 0: increment, 1: decrement

    // Update wave based on direction each clock cycle
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n)
            wave <= 5'd0;
        else if (direction == 1'b0)
            wave <= (wave == 5'd31) ? wave : wave + 5'd1;
        else
            wave <= (wave == 5'd0) ? wave : wave - 5'd1;
    end

    // Update direction only at wave boundary conditions
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n)
            direction <= 1'b0;
        else begin
            if (wave == 5'd31)
                direction <= 1'b1;
            else if (wave == 5'd0)
                direction <= 1'b0;
        end
    end

endmodule