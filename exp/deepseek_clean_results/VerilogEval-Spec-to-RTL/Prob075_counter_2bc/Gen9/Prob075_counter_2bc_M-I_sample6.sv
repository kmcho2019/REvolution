module TopModule (
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output [1:0] state
);

    reg [1:0] counter = 2'b01;  // Initialize to weakly not-taken (helps some synthesis tools)

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            counter <= 2'b01;
        end else if (train_valid) begin
            case ({train_taken, counter})
                3'b0_00: counter <= 2'b00;  // Stay at min
                3'b0_01: counter <= 2'b00;
                3'b0_10: counter <= 2'b01;
                3'b0_11: counter <= 2'b10;
                3'b1_00: counter <= 2'b01;
                3'b1_01: counter <= 2'b10;
                3'b1_10: counter <= 2'b11;
                3'b1_11: counter <= 2'b11;  // Stay at max
            endcase
        end
        // else hold value (implicit)
    end

    assign state = counter;

endmodule