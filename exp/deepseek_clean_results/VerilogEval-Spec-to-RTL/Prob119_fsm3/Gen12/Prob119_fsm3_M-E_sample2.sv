module TopModule (
    input clk,
    input areset,
    input in,
    output reg out
);

    // One-hot state encoding
    reg [3:0] state;
    localparam A = 4'b0001;
    localparam B = 4'b0010;
    localparam C = 4'b0100;
    localparam D = 4'b1000;

    // Next state logic as parallel equations
    wire [3:0] next_state;
    assign next_state[A] = (state[A] & ~in) | (state[C] & ~in);
    assign next_state[B] = (state[A] & in) | (state[B] & in) | (state[D] & in);
    assign next_state[C] = (state[B] & ~in) | (state[C] & ~in) | (state[D] & ~in);
    assign next_state[D] = (state[C] & in);

    // State register with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= A;
        end else begin
            state <= next_state;
        end
    end

    // Registered output for better timing
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            out <= 1'b0;
        end else begin
            out <= (next_state == D);
        end
    end

endmodule