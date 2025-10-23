module TopModule (
    input  clk,
    input  areset,
    input  train_valid,
    input  train_taken,
    output reg [1:0] state
);

    reg [1:0] next_state;

    // Combinational next state logic
    always @(*) begin
        if (train_valid) begin
            if (train_taken) begin
                if (state != 2'b11)
                    next_state = state + 1;
                else
                    next_state = state;
            end else begin
                if (state != 2'b00)
                    next_state = state - 1;
                else
                    next_state = state;
            end
        end else begin
            next_state = state;
        end
    end

    // Sequential state update with async posedge reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 2'b01;
        else
            state <= next_state;
    end

endmodule