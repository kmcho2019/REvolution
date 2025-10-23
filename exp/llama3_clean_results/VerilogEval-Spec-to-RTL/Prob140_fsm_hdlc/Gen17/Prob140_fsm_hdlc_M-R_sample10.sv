module TopModule(
    input  clk,
    input  reset,
    input  in,
    output disc,
    output flag,
    output err
);

reg [2:0] state;
reg [5:0] ones_count;
reg disc_reg, flag_reg, err_reg;

always @(posedge clk) begin
    if (reset) begin
        state <= 0;
        ones_count <= 0;
        disc_reg <= 0;
        flag_reg <= 0;
        err_reg <= 0;
    end else begin
        disc_reg <= 0;
        flag_reg <= 0;
        err_reg <= 0;
        
        if (in) begin
            ones_count <= ones_count + 1;
            if (ones_count == 6) begin
                state <= 1; // Flag detected
            end else if (ones_count >= 7) begin
                state <= 2; // Error condition
            end
        end else begin
            if (ones_count == 5) begin
                disc_reg <= 1; // Discard bit
            end else if (state == 1) begin
                flag_reg <= 1; // Assert flag
            end
            ones_count <= 0;
            state <= 0; // Reset state
        end
        
        if (state == 2) begin
            err_reg <= 1; // Assert error
        end
    end
end

assign disc = disc_reg;
assign flag = flag_reg;
assign err = err_reg;

endmodule