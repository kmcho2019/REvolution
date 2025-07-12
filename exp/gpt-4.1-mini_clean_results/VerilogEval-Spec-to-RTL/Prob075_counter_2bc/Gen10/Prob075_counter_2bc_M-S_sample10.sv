module TopModule (
    input  wire       clk,
    input  wire       areset,
    input  wire       train_valid,
    input  wire       train_taken,
    output reg  [1:0] state
);

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 2'b01; // weakly not-taken reset state
        end else if (train_valid) begin
            if (train_taken && state != 2'b11)
                state <= state + 1'b1;
            else if (!train_taken && state != 2'b00)
                state <= state - 1'b1;
            // else hold current state if saturating
        end
        // else hold current state when not training
    end

endmodule