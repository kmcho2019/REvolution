module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire train_valid,
    input  wire train_taken,
    output reg  [1:0] state
);

    // Calculate next state with saturating increment/decrement
    wire [1:0] next_state;
    wire       inc = train_valid & train_taken & (state != 2'd3);
    wire       dec = train_valid & ~train_taken & (state != 2'd0);
    wire       update = inc | dec;

    assign next_state = inc ? (state + 1) :
                        dec ? (state - 1) :
                        state;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 2'b01; // weakly not-taken reset state
        end else if (update) begin
            state <= next_state;
        end
        // else keep state unchanged
    end

endmodule