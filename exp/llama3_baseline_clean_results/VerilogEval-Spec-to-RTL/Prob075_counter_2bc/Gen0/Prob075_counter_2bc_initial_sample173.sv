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
                state <= (state == 3) ? 3 : state + 1;
            end else begin
                state <= (state == 0) ? 0 : state - 1;
            end
        end
    end
end

endmodule