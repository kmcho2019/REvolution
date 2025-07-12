module edge_detect(
    input  clk,
    input  rst_n,
    input  a,
    output rise,
    output down
);

reg prev_a; // Register to store the previous state of 'a'
reg rise_reg; // Register for the rise signal
reg down_reg; // Register for the down signal

assign rise = rise_reg;
assign down = down_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset the registers
        prev_a <= 0;
        rise_reg <= 0;
        down_reg <= 0;
    end else begin
        // Store the current state of 'a' as the previous state for the next clock cycle
        prev_a <= a;
        
        // Check for rising edge
        if (prev_a == 0 && a == 1) begin
            rise_reg <= 1;
        end else begin
            rise_reg <= 0;
        end
        
        // Check for falling edge
        if (prev_a == 1 && a == 0) begin
            down_reg <= 1;
        end else begin
            down_reg <= 0;
        end
    end
end

endmodule