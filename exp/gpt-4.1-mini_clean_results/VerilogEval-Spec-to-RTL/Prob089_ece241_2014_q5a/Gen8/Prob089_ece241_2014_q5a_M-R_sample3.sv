module TopModule (
    input        clk,
    input        areset,
    input        x,
    output reg   z
);

    // One-hot state encoding
    // s[1:0] = 2'b01 -> S0 (waiting for first '1')
    //           2'b10 -> S1 (inverting subsequent bits)
    reg [1:0] state;
    wire [1:0] next_state;

    reg x_reg;  // Registered input bit

    // Next state logic combinational with one-hot encoding
    assign next_state[0] = (state[0] && (x_reg == 1'b0)) || (state[1] && 1'b0); // Stay in S0 if x_reg=0, no transition back from S1
    assign next_state[1] = (state[0] && (x_reg == 1'b1)) || state[1];           // Move to S1 on first '1', stay in S1 after

    // State, input, and output registers with async reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 2'b01;   // S0 active
            x_reg <= 1'b0;
            z <= 1'b0;
        end else begin
            state <= next_state;
            x_reg <= x;

            // Moore output logic depends only on current registered input and state
            if (state[0])        // S0
                z <= x_reg;
            else if (state[1])   // S1
                z <= ~x_reg;
            else
                z <= 1'b0;       // Safe default
        end
    end

endmodule