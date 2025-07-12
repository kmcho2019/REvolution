module TopModule (
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output reg [1:0] state
);

    wire [2:0] next_val; // 3 bits to detect overflow/underflow

    // Calculate next value with saturating arithmetic
    assign next_val = train_valid ? (train_taken ? state + 1 : state - 1) : state;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 2'b01; // weakly not-taken
        end else begin
            // Clamp next_val between 0 and 3
            if (train_valid) begin
                if (next_val[2])       // negative overflow if bit2 is set after subtraction
                    state <= 2'b00;
                else if (next_val > 3)
                    state <= 2'b11;
                else
                    state <= next_val[1:0];
            end
            // else hold state
        end
    end

endmodule