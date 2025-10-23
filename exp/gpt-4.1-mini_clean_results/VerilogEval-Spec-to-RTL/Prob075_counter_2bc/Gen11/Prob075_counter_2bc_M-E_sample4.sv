module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire train_valid,
    input  wire train_taken,
    output reg [1:0] state
);

    reg [1:0] counter;

    // Saturating increment/decrement logic
    wire [2:0] incremented = counter + 1;
    wire [2:0] decremented = counter - 1;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            counter <= 2'b01; // Reset to weakly not-taken
        end else if (train_valid) begin
            if (train_taken) begin
                // Saturate increment at 3
                if (counter < 2'b11)
                    counter <= incremented[1:0];
                else
                    counter <= counter;
            end else begin
                // Saturate decrement at 0
                if (counter > 2'b00)
                    counter <= decremented[1:0];
                else
                    counter <= counter;
            end
        end
    end

    always @(*) begin
        state = counter;
    end

endmodule