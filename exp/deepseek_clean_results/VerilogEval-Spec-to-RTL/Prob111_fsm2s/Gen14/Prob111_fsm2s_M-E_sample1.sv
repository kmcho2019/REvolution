module TopModule (
    input clk,
    input reset,
    input j,
    input k,
    output out
);

    reg [1:0] state; // [1] is current state, [0] is previous input

    always @(posedge clk) begin
        if (reset) begin
            state <= 2'b00; // Reset to OFF state
        end
        else begin
            state <= {state[0] ? ~k : j, j}; // Next state logic
        end
    end

    assign out = state[1]; // Output is current state bit

endmodule