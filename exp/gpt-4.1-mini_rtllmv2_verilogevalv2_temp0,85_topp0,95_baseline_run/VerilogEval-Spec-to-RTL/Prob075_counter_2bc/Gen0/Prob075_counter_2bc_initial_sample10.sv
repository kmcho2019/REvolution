module TopModule(
    input        clk,
    input        areset,
    input        train_valid,
    input        train_taken,
    output reg [1:0] state
);

    // Internal register for the saturating counter
    reg [1:0] counter;

    // Asynchronous reset with synchronous counter update
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            counter <= 2'b01; // weakly not-taken
        end else if (train_valid) begin
            if (train_taken) begin
                // increment with saturation at 3
                if (counter != 2'b11)
                    counter <= counter + 1;
                else
                    counter <= counter;
            end else begin
                // decrement with saturation at 0
                if (counter != 2'b00)
                    counter <= counter - 1;
                else
                    counter <= counter;
            end
        end else begin
            // hold state when train_valid == 0
            counter <= counter;
        end
    end

    // Assign counter to output state
    always @(*) begin
        state = counter;
    end

endmodule