module TopModule(
    input  clk,
    input  areset,
    input  train_valid,
    input  train_taken,
    output [1:0] state
);

reg [1:0] state_reg;
assign state = state_reg;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state_reg <= 2'b01;
    end else begin
        reg [1:0] next_state;
        next_state = state_reg;
        
        if (train_valid) begin
            if (train_taken) begin
                next_state = state_reg + 1'b1;
            end else begin
                next_state = state_reg - 1'b1;
            end
        end
        
        // saturation check
        if (next_state > 2'b11) begin
            next_state = 2'b11;
        end else if (next_state < 2'b00) begin
            next_state = 2'b00;
        end
        
        state_reg <= next_state;
    end
end

endmodule