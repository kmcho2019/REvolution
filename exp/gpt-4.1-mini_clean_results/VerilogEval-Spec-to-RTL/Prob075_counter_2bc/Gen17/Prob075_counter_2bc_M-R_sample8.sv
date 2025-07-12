module TopModule (
    input  wire       clk,
    input  wire       areset,
    input  wire       train_valid,
    input  wire       train_taken,
    output wire [1:0] state
);

    reg [1:0] counter_reg;
    reg [1:0] next_counter;

    // Combinational logic to calculate next state with saturation
    always @(*) begin
        if (train_valid) begin
            if (train_taken) begin
                // Increment saturating at 3
                if (counter_reg < 2'b11)
                    next_counter = counter_reg + 1'b1;
                else
                    next_counter = 2'b11;
            end else begin
                // Decrement saturating at 0
                if (counter_reg > 2'b00)
                    next_counter = counter_reg - 1'b1;
                else
                    next_counter = 2'b00;
            end
        end else begin
            next_counter = counter_reg;
        end
    end

    // Sequential logic with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            counter_reg <= 2'b01;  // weakly not-taken reset state
        end else begin
            counter_reg <= next_counter;
        end
    end

    assign state = counter_reg;

endmodule