module TopModule (
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

    // One-hot encoded states (s0-s7)
    reg [7:0] state;
    wire [7:0] next_state;

    // Next state logic (combinational)
    assign next_state[0] = ~in & (state[0] | state[1] | state[2] | state[3] | state[4] | state[5] | state[6] | state[7]);
    assign next_state[1] = in & state[0];
    assign next_state[2] = in & state[1];
    assign next_state[3] = in & state[2];
    assign next_state[4] = in & state[3];
    assign next_state[5] = in & state[4];
    assign next_state[6] = in & state[5];
    assign next_state[7] = in & (state[6] | state[7]);

    // State register with clock gating
    always @(posedge clk) begin
        if (reset) begin
            state <= 8'b00000001; // Reset to state 0
        end else if (in || |state[7:1]) begin // Only update when counting or input is 1
            state <= next_state;
        end
    end

    // Output logic (registered)
    always @(posedge clk) begin
        if (reset) begin
            disc <= 0;
            flag <= 0;
            err <= 0;
        end else begin
            disc <= (state[5] & ~in);
            flag <= (state[6] & ~in);
            err <= (state[6] & in) | state[7];
        end
    end

endmodule