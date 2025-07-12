module TopModule (
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output [1:0] state
);

    reg [1:0] counter;
    reg [1:0] next_counter;

    always @(*) begin
        if (areset) begin
            next_counter = 2'b01;  // Reset condition
        end else if (train_valid) begin
            // Pre-calculate both possible next states
            case ({train_taken, counter})
                3'b000: next_counter = 2'b00;  // Decrement with saturation
                3'b001: next_counter = 2'b00;
                3'b010: next_counter = 2'b01;
                3'b011: next_counter = 2'b10;
                3'b100: next_counter = 2'b01;  // Increment with saturation
                3'b101: next_counter = 2'b10;
                3'b110: next_counter = 2'b11;
                3'b111: next_counter = 2'b11;
                default: next_counter = counter;
            endcase
        end else begin
            next_counter = counter;  // Hold when not training
        end
    end

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            counter <= 2'b01;  // Reset to weakly not-taken
        end else begin
            counter <= next_counter;
        end
    end

    assign state = counter;

endmodule