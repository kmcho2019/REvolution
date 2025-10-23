module TopModule (
    input  wire       clk,
    input  wire       areset,
    input  wire       train_valid,
    input  wire       train_taken,
    output reg [1:0]  state
);

always @(posedge clk) begin
    if (areset)
        state <= 2'b01; // weakly not-taken synchronous reset
    else if (train_valid) begin
        if (train_taken) begin
            if (state != 2'b11)
                state <= state + 1'b1;
            else
                state <= state;
        end else begin
            if (state != 2'b00)
                state <= state - 1'b1;
            else
                state <= state;
        end
    end
    // else hold state
end

endmodule