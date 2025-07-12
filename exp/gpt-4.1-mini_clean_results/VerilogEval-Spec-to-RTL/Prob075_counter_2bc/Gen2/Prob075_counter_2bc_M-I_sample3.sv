module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire train_valid,
    input  wire train_taken,
    output reg [1:0] state
);

    // Asynchronous positive edge reset and saturating counter logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 2'b01; // weakly not-taken
        end else if (train_valid) begin
            // Use min/max style saturating increment/decrement
            if (train_taken && (state != 2'b11))
                state <= state + 1'b1;
            else if (!train_taken && (state != 2'b00))
                state <= state - 1'b1;
            else
                state <= state; // hold if at saturation
        end
        // else hold state unchanged
    end

endmodule