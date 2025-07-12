module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire train_valid,
    input  wire train_taken,
    output reg [1:0] state
);

    // Asynchronous positive edge reset, synchronous saturating counter update
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 2'b01;  // weakly not-taken
        end else if (train_valid) begin
            // Compute next state with saturating arithmetic
            state <= train_taken
                     ? (state < 2'b11 ? state + 1'b1 : 2'b11)
                     : (state > 2'b00 ? state - 1'b1 : 2'b00);
        end
        // else hold current state
    end

endmodule