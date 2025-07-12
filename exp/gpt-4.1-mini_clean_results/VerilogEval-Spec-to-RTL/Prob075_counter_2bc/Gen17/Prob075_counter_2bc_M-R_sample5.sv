module TopModule (
    input  wire       clk,
    input  wire       areset,
    input  wire       train_valid,
    input  wire       train_taken,
    output reg  [1:0] state
);

    wire [1:0] next_state;
    wire       inc, dec;

    assign inc = train_valid & train_taken;
    assign dec = train_valid & ~train_taken;

    // Saturating increment/decrement logic:
    // Increment if inc and state < 3
    // Decrement if dec and state > 0
    // Hold otherwise
    assign next_state = (inc & (state != 2'd3)) ? (state + 2'd1) :
                        (dec & (state != 2'd0)) ? (state - 2'd1) :
                        state;

    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 2'b01; // weakly not-taken reset state
        else
            state <= next_state;
    end

endmodule