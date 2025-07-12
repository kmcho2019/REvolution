module TopModule (
    input  wire       clk,
    input  wire       areset,
    input  wire       train_valid,
    input  wire       train_taken,
    output reg [1:0]  state
);

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 2'b01;
        end else if (train_valid) begin
            // Calculate next state with saturating increment/decrement
            case (train_taken)
                1'b1: state <= (state < 2'd3) ? state + 1 : state;
                1'b0: state <= (state > 2'd0) ? state - 1 : state;
            endcase
        end
        // else hold state
    end

endmodule