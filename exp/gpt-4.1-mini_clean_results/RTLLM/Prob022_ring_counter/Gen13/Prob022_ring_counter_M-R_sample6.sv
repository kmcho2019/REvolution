module ring_counter (
    input clk,
    input reset,
    output reg [7:0] out
);

    reg [7:0] state;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 8'b00000001;
        end else begin
            state <= {state[6:0], state[7]};
        end
    end

    always @(*) begin
        out = state;
    end

endmodule