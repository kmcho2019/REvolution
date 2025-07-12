module TopModule (
    input clk,
    input reset,
    output shift_ena
);

    reg [3:0] state;
    wire [3:0] next_state;

    // Next state logic (combinational)
    assign next_state = reset ? 4'b1111 : {state[2:0], 1'b0};

    // Output logic
    assign shift_ena = state[3];

    // State update (sequential)
    always @(posedge clk) begin
        state <= next_state;
    end

endmodule