module TopModule (
    input  wire       clk,
    input  wire       areset,
    input  wire       train_valid,
    input  wire       train_taken,
    output reg  [1:0] state
);

    reg [1:0] next_state;

    always @* begin
        if (!train_valid) begin
            next_state = state;
        end else if (train_taken) begin
            next_state = (state == 2'b11) ? 2'b11 : (state + 1);
        end else begin
            next_state = (state == 2'b00) ? 2'b00 : (state - 1);
        end
    end

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 2'b01;  // weakly not-taken reset state
        end else begin
            state <= next_state;
        end
    end

endmodule