module TopModule(
    input           clk,
    input           areset,
    input           train_valid,
    input           train_taken,
    output reg [1:0] state
);

// Define a parameterizable increment/decrement module
module saturating_counter #(
    parameter MIN_VALUE = 0,
    parameter MAX_VALUE = 3
) (
    input           clk,
    input           en,
    input           increment,
    input [1:0]     curr_value,
    output reg [1:0] next_value
);

    always @(posedge clk) begin
        if (en) begin
            if (increment) begin
                if (curr_value == MAX_VALUE) begin
                    next_value <= MAX_VALUE; // Saturate at maximum value
                end else begin
                    next_value <= curr_value + 1;
                end
            end else begin
                if (curr_value == MIN_VALUE) begin
                    next_value <= MIN_VALUE; // Saturate at minimum value
                end else begin
                    next_value <= curr_value - 1;
                end
            end
        end else begin
            next_value <= curr_value; // Hold current value if not enabled
        end
    end

endmodule

// Instantiate the saturating counter module
wire en;
wire increment;

assign en = train_valid; // Enable counter update when training is valid
assign increment = train_taken; // Determine direction based on train_taken

saturating_counter #(
    .MIN_VALUE(0),
    .MAX_VALUE(3)
) counter_inst (
    .clk(clk),
    .en(en),
    .increment(increment),
    .curr_value(state),
    .next_value(state)
);

// Asynchronous reset to weakly not-taken state
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b01;
    end
end

endmodule