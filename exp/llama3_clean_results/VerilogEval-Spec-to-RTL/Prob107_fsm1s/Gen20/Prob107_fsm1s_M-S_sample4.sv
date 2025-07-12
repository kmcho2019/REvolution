module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

// Define states using binary encoding
localparam STATE_B = 1'b0;
localparam STATE_A = 1'b1;

reg state; // State variable

always @(posedge clk) begin
    if(reset) begin
        state <= STATE_B; // Reset to state B
    end else begin
        if (state == STATE_B) begin
            state <= in ? STATE_B : STATE_A;
        end else begin
            state <= in ? STATE_A : STATE_B;
        end
    end
end

assign out = ~state; // Output directly related to the state

endmodule