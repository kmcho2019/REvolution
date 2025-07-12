module signal_generator (
    input             clk,
    input             rst_n,
    output reg [4:0]  wave
);

    // State encoding
    localparam INC = 1'b0;
    localparam DEC = 1'b1;

    reg state;

    // Combinational calculation of next wave value
    wire [4:0] next_wave = (state == INC) ? 
                            ((wave == 5'd31) ? wave : wave + 5'd1) :
                            ((wave == 5'd0) ? wave : wave - 5'd1);

    // Sequential logic: update wave and state on clock or async reset
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            wave  <= 5'd0;
            state <= INC;
        end else begin
            wave <= next_wave;
            // Toggle state when wave hits boundary
            if ((state == INC && wave == 5'd31) || (state == DEC && wave == 5'd0))
                state <= ~state;
        end
    end

endmodule