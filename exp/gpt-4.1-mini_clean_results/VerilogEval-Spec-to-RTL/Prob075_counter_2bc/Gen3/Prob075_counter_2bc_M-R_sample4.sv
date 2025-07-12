module TopModule (
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output reg [1:0] state
);

    reg [1:0] next_state;

    // Combinational logic to compute next_state
    always @(*) begin
        if (train_valid) begin
            if (train_taken) begin
                // Increment with saturation at 3
                if (state < 2'b11)
                    next_state = state + 1'b1;
                else
                    next_state = 2'b11;
            end else begin
                // Decrement with saturation at 0
                if (state > 2'b00)
                    next_state = state - 1'b1;
                else
                    next_state = 2'b00;
            end
        end else begin
            next_state = state; // Hold current state if not training
        end
    end

    // Sequential block with asynchronous positive edge reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 2'b01;
        end else begin
            state <= next_state;
        end
    end

endmodule