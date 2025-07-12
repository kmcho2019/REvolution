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
            counter <= 2'b01;  // reset to weakly not-taken
        end else if (train_valid) begin
            case ({train_taken, counter})
                // Increment cases (when train_taken=1 and not at max)
                3'b1_00: counter <= 2'b01;
                3'b1_01: counter <= 2'b10;
                3'b1_10: counter <= 2'b11;
                3'b1_11: counter <= 2'b11;  // saturate at max
                // Decrement cases (when train_taken=0 and not at min)
                3'b0_01: counter <= 2'b00;
                3'b0_10: counter <= 2'b01;
                3'b0_11: counter <= 2'b10;
                3'b0_00: counter <= 2'b00;  // saturate at min
                default: counter <= counter;
            endcase
        end
        // else counter maintains its value
    end

    assign state = counter;

endmodule