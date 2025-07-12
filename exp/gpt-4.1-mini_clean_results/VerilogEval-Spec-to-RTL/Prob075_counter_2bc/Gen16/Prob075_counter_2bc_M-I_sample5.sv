module TopModule (
    input  wire       clk,
    input  wire       areset,
    input  wire       train_valid,
    input  wire       train_taken,
    output reg [1:0]  state
);

    wire enable = train_valid;
    wire inc = enable & train_taken & (state != 2'b11);
    wire dec = enable & (~train_taken) & (state != 2'b00);

    // Compute next state based on enable signals
    wire [1:0] next_state = inc ? (state + 1) :
                            (dec ? (state - 1) : state);

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 2'b01;  // weakly not-taken reset value
        end else begin
            state <= next_state;
        end
    end

endmodule