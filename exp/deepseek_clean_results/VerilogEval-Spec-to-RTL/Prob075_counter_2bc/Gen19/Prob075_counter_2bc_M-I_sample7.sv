module TopModule (
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output [1:0] state
);

    reg [1:0] counter;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            counter <= 2'b01;  // Reset to weakly not-taken
        end else if (train_valid) begin
            case ({train_taken, counter})
                3'b000: counter <= 2'b00;  // Decrement saturate at 0
                3'b001: counter <= 2'b00;
                3'b010: counter <= 2'b01;
                3'b011: counter <= 2'b10;
                3'b100: counter <= 2'b01;  // Increment
                3'b101: counter <= 2'b10;
                3'b110: counter <= 2'b11;
                3'b111: counter <= 2'b11;  // Increment saturate at 3
            endcase
        end
        // else hold value (implicit)
    end

    assign state = counter;

endmodule