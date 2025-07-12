module TopModule (
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output [1:0] state
);

    reg [1:0] counter;
    wire counter_enable = train_valid;
    wire counter_dir = train_taken;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            counter <= 2'b01;  // Reset to weakly not-taken
        end else if (counter_enable) begin
            case ({counter_dir, counter})
                // Increment cases (train_taken=1)
                3'b1_00: counter <= 2'b01;
                3'b1_01: counter <= 2'b10;
                3'b1_10: counter <= 2'b11;
                3'b1_11: counter <= 2'b11; // saturate
                
                // Decrement cases (train_taken=0)
                3'b0_01: counter <= 2'b00;
                3'b0_10: counter <= 2'b01;
                3'b0_11: counter <= 2'b10;
                3'b0_00: counter <= 2'b00; // saturate
                
                default: counter <= counter;
            endcase
        end
    end

    assign state = counter;

endmodule