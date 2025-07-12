module TopModule(output one);
    reg q;
    wire d, clk, rst_n;
    
    // Tie inputs appropriately
    assign d = 1;
    assign clk = 0;  // Clock not needed for constant output
    assign rst_n = 0;  // Active low reset
    
    // D flip-flop with async reset
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            q <= 1;
        else
            q <= d;
    end
    
    assign one = q;
endmodule