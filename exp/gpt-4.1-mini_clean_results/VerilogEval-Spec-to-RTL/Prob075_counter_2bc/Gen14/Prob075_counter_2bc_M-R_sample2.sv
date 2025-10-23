module TopModule (
    input  wire       clk,
    input  wire       areset,
    input  wire       train_valid,
    input  wire       train_taken,
    output reg  [1:0] state
);

    // Asynchronous positive edge reset sets state to weakly not-taken (2'b01)
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 2'b01;
        end else begin
            state <= next_state;
        end
    end

    wire [1:0] next_state;

    // Compute next_state with saturating arithmetic when train_valid is asserted
    // Increment up to 3, decrement down to 0, else hold state
    assign next_state = train_valid ? (
        train_taken ? 
            (state == 2'b11 ? 2'b11 : state + 1'b1) :  // saturate increment at 3
            (state == 2'b00 ? 2'b00 : state - 1'b1)    // saturate decrement at 0
    ) : state;  // hold current state when train_valid is 0

endmodule