module TopModule (
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output [1:0] state
);

    reg [1:0] counter;
    wire [1:0] next_counter;

    // Optimized next state logic:
    // 1. Reset has highest priority
    // 2. Then training conditions with saturation
    // 3. Finally hold state when not training
    assign next_counter = areset ? 2'b01 :
                         train_valid ? 
                         (train_taken ? (counter + (counter != 2'b11)) : 
                                        (counter - (counter != 2'b00))) :
                         counter;

    // Sequential logic with async reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            counter <= 2'b01;
        else
            counter <= next_counter;
    end

    assign state = counter;

endmodule