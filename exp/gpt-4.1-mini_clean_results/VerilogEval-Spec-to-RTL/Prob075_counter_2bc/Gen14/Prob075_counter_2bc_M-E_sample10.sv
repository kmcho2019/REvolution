module TopModule (
    input  wire        clk,
    input  wire        areset,
    input  wire        train_valid,
    input  wire        train_taken,
    output reg  [1:0]  state
);

    // Saturating increment/decrement helper function
    function [1:0] saturating_inc(input [1:0] val);
        saturating_inc = (val == 2'b11) ? 2'b11 : val + 1;
    endfunction

    function [1:0] saturating_dec(input [1:0] val);
        saturating_dec = (val == 2'b00) ? 2'b00 : val - 1;
    endfunction

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 2'b01;  // weakly not-taken on reset
        end else if (train_valid) begin
            if (train_taken)
                state <= saturating_inc(state);
            else
                state <= saturating_dec(state);
        end else begin
            state <= state; // hold state if not training
        end
    end

endmodule