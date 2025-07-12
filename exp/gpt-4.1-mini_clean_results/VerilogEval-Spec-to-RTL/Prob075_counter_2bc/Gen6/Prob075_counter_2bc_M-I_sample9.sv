module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire train_valid,
    input  wire train_taken,
    output reg [1:0] state
);

    reg [1:0] next_state;
    integer signed temp;

    always @(*) begin
        // Compute tentative next state as signed integer
        if (train_valid) begin
            temp = $signed({1'b0,state}) + (train_taken ? 1 : -1);
        end else begin
            temp = $signed({1'b0,state});
        end

        // Clamp between 0 and 3
        if (temp < 0)
            temp = 0;
        else if (temp > 3)
            temp = 3;

        next_state = temp[1:0];
    end

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 2'b01; // weakly not-taken
        end else begin
            state <= next_state;
        end
    end

endmodule