module signal_generator (
    input             clk,
    input             rst_n,
    output reg [4:0]  wave
);

    reg state; // 0: increment, 1: decrement

    wire [4:0] wave_next;

    // Combinational calculation of next wave value based on current state and wave
    assign wave_next = (state == 1'b0) ? 
                       ((wave == 5'd31) ? wave : wave + 5'd1) : 
                       ((wave == 5'd0)  ? wave : wave - 5'd1);

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            wave  <= 5'd0;
            state <= 1'b0;
        end else begin
            wave <= wave_next;
            // Toggle state when wave reaches boundary values
            if ((state == 1'b0 && wave == 5'd31) || (state == 1'b1 && wave == 5'd0)) begin
                state <= ~state;
            end
        end
    end

endmodule