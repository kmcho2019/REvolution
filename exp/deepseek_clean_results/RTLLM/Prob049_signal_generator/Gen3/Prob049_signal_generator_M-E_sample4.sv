module signal_generator (
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg dir; // 0 = increment, 1 = decrement

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        wave <= 5'b0;
        dir <= 1'b0;
    end
    else begin
        // Update wave based on current direction
        wave <= dir ? wave - 1'b1 : wave + 1'b1;
        
        // Toggle direction at boundaries
        if ((wave == 5'd30 && !dir) || (wave == 5'd1 && dir)) begin
            dir <= ~dir;
        end
    end
end

endmodule