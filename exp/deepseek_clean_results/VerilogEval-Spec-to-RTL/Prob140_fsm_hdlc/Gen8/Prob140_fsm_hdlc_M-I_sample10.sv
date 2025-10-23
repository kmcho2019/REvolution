module TopModule (
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

    // One-hot encoded states (S0-S6)
    reg [6:0] state;
    wire [6:0] next_state;

    // Next state logic
    assign next_state[0] = (~in & (state[0] | state[1] | state[2] | state[3] | state[4] | state[5] | state[6])) | 
                          (reset);
    assign next_state[1] = in & (state[0] | state[1]);
    assign next_state[2] = in & state[1];
    assign next_state[3] = in & state[2];
    assign next_state[4] = in & state[3];
    assign next_state[5] = in & state[4];
    assign next_state[6] = in & (state[5] | state[6]);

    // Output logic
    wire disc_cond = state[5] & ~in;
    wire flag_cond = state[6] & ~in;
    wire err_cond = state[6] & in;

    always @(posedge clk) begin
        if (reset) begin
            state <= 7'b0000001;  // S0
            disc <= 0;
            flag <= 0;
            err <= 0;
        end else begin
            // Update state only when input changes the count
            if (in != (state[0] | state[1])) begin
                state <= next_state;
            end

            // Update outputs only when conditions change
            disc <= disc_cond;
            flag <= flag_cond;
            err <= err_cond;
        end
    end

endmodule