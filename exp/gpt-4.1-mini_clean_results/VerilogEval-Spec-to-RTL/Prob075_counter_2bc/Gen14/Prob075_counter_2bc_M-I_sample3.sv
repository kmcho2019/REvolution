module TopModule (
    input  wire        clk,
    input  wire        areset,
    input  wire        train_valid,
    input  wire        train_taken,
    output reg  [1:0]  state
);

    // Saturating increment/decrement with explicit min/max in combinational logic
    wire [1:0] inc_state = (state == 2'd3) ? 2'd3 : state + 2'd1;
    wire [1:0] dec_state = (state == 2'd0) ? 2'd0 : state - 2'd1;

    wire [1:0] next_state = train_valid ? (train_taken ? inc_state : dec_state) : state;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 2'b01; // weakly not-taken
        end else begin
            state <= next_state;
        end
    end

endmodule