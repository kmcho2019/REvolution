module TopModule (
    input  wire       clk,
    input  wire       areset,
    input  wire       train_valid,
    input  wire       train_taken,
    output reg  [1:0] state
);

    wire inc_enable = train_valid & train_taken;
    wire dec_enable = train_valid & ~train_taken;

    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 2'b01;
        else begin
            if (inc_enable) begin
                if (state != 2'b11)
                    state <= state + 1;
                else
                    state <= state;
            end
            else if (dec_enable) begin
                if (state != 2'b00)
                    state <= state - 1;
                else
                    state <= state;
            end
            else begin
                state <= state; // hold
            end
        end
    end

endmodule