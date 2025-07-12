module TopModule (
    input  wire       clk,
    input  wire       areset,
    input  wire       train_valid,
    input  wire       train_taken,
    output reg  [1:0] state
);

    reg [1:0] next_state;
    wire inc = train_valid & train_taken;
    wire dec = train_valid & (~train_taken);

    always @(*) begin
        if (inc) begin
            // saturate at max 3
            if (state == 2'b11)
                next_state = 2'b11;
            else
                next_state = state + 1'b1;
        end else if (dec) begin
            // saturate at min 0
            if (state == 2'b00)
                next_state = 2'b00;
            else
                next_state = state - 1'b1;
        end else begin
            next_state = state; // hold current state
        end
    end

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 2'b01; // weakly not-taken state
        end else begin
            state <= next_state;
        end
    end

endmodule