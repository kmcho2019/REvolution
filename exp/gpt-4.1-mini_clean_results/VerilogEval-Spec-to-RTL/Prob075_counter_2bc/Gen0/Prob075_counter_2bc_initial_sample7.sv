module TopModule(
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output reg [1:0] state
);

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b01;
    end else begin
        if (train_valid) begin
            if (train_taken) begin
                // increment saturating at 3
                if (state != 2'b11)
                    state <= state + 1;
            end else begin
                // decrement saturating at 0
                if (state != 2'b00)
                    state <= state - 1;
            end
        end
    end
end

endmodule