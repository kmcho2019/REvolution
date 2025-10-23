module TopModule (
    input  clk,
    input  areset,
    input  in,
    output reg out
);

    // One-hot encoding states
    localparam A = 2'b01;
    localparam B = 2'b10;

    reg [1:0] state;

    // State transition and async reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= B;
        else
            case (state)
                B: state <= (in == 1'b0) ? A : B;
                A: state <= (in == 1'b0) ? B : A;
                default: state <= B;
            endcase
    end

    // Moore output logic: output = 1 if in B, else 0
    always @(posedge clk or posedge areset) begin
        if (areset)
            out <= 1'b1;       // Output for state B
        else
            out <= state[1];   // B is 2'b10, so out = 1 if B, 0 if A
    end

endmodule