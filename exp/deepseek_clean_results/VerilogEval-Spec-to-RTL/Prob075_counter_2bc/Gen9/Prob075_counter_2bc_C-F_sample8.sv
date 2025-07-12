module TopModule (
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output [1:0] state
);

    localparam RESET_VALUE = 2'b01;
    reg [1:0] counter;

    // Optimized next state logic
    wire [1:0] next_counter;
    assign next_counter = areset ? RESET_VALUE : 
                        (train_valid ? 
                            (train_taken ? (counter + (counter != 2'b11)) : 
                                           (counter - (counter != 2'b00))) : 
                            counter);

    // Sequential logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            counter <= RESET_VALUE;
        end else begin
            counter <= next_counter;
        end
    end

    assign state = counter;

endmodule