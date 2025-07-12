module TopModule(
    input clk,
    input reset,
    input j,
    input k,
    output reg out
);

    reg state;  // 0 = OFF, 1 = ON
    wire next_state;

    // Combinational next state logic
    assign next_state = (state == 1'b0) ? (j ? 1'b1 : 1'b0) :
                        (k ? 1'b0 : 1'b1);

    // State update and output logic combined
    always @(posedge clk) begin
        if (reset) begin
            state <= 1'b0;  // OFF state
            out <= 1'b0;
        end else begin
            state <= next_state;
            out <= next_state;  // output reflects new state (Moore)
        end
    end

endmodule