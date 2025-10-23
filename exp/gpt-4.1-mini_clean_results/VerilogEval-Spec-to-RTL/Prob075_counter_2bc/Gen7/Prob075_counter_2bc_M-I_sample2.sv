module TopModule (
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output reg [1:0] state
);

    wire [1:0] next_state;
    wire       clk_en;

    assign clk_en = train_valid;

    // Next state logic: increment saturating at 3, decrement saturating at 0
    assign next_state = train_taken ?
                        (state == 2'b11 ? 2'b11 : state + 1'b1) :
                        (state == 2'b00 ? 2'b00 : state - 1'b1);

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 2'b01;
        end else if (clk_en) begin
            state <= next_state;
        end
        // else retain state (implicit)
    end

endmodule