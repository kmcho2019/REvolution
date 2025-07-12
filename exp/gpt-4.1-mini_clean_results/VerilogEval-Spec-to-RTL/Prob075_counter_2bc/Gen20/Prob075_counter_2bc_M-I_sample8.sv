module TopModule (
    input  wire       clk,
    input  wire       areset,
    input  wire       train_valid,
    input  wire       train_taken,
    output reg [1:0]  state
);

    reg [1:0] next_state;
    wire signed [2:0] delta = (train_valid) ? (train_taken ? 3'sd1 : -3'sd1) : 3'sd0;
    wire enable;

    // Combinational next state calculation with saturation
    always @(*) begin
        // Add delta to current state with saturation between 0 and 3
        int signed [3:0] temp;  // wider to avoid overflow
        temp = $signed({1'b0, state}) + delta; // extend state to signed 3 bits
        if (temp < 0)
            next_state = 2'd0;
        else if (temp > 3)
            next_state = 2'd3;
        else
            next_state = temp[1:0];
    end

    // Enable register update only when state changes (power saving)
    assign enable = (train_valid && (next_state != state));

    // Sequential logic with async positive edge reset and enable
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 2'b01;  // weakly not-taken reset state
        end else if (enable) begin
            state <= next_state;
        end
        // else retain previous state (no toggle)
    end

endmodule