module signal_generator (
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg dir;  // 0 = increment, 1 = decrement

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        wave <= 5'b0;
        dir <= 1'b0;
    end else begin
        // Update wave with direction control
        wave <= wave + {4'b0,~dir} + dir;
        
        // Toggle direction at boundaries
        if ((wave == 5'b11111 && ~dir) || (wave == 5'b00000 && dir))
            dir <= ~dir;
    end
end

endmodule