module TopModule(
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output reg [1:0] state
);

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b01; // weakly not-taken
    end else begin
        if (train_valid) begin
            if (train_taken) begin
                if (state == 2'b11) begin
                    state <= 2'b11; // saturate at '11'
                end else begin
                    state <= state + 1'b1; // increment
                end
            end else begin
                if (state == 2'b00) begin
                    state <= 2'b00; // saturate at '00'
                end else begin
                    state <= state - 1'b1; // decrement
                end
            end
        end else begin
            // keep state unchanged
        end
    end
end

endmodule