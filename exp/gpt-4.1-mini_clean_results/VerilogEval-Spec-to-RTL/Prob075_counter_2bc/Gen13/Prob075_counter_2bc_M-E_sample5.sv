module TopModule (
    input  wire       clk,
    input  wire       areset,
    input  wire       train_valid,
    input  wire       train_taken,
    output reg [1:0]  state
);

    integer signed delta;
    integer signed next_int;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 2'b01;  // weakly not-taken
        end else begin
            // Determine delta: +1 if taken and valid, -1 if not taken and valid, else 0
            if (train_valid) begin
                delta = train_taken ? 1 : -1;
            end else begin
                delta = 0;
            end

            // Compute next state as signed integer
            next_int = $signed(state) + delta;

            // Saturate to [0,3]
            if (next_int < 0)
                next_int = 0;
            else if (next_int > 3)
                next_int = 3;

            state <= next_int[1:0];
        end
    end

endmodule