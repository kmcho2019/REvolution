module TopModule (
    input clk,
    input reset,
    input x,
    output z
);

    // One-hot state encoding
    parameter S0 = 5'b00001;
    parameter S1 = 5'b00010;
    parameter S2 = 5'b00100;
    parameter S3 = 5'b01000;
    parameter S4 = 5'b10000;

    reg [4:0] state;

    // Next state logic (parallel computation)
    wire next_S0 = (~reset) & ((state == S0 & ~x) | (state == S3 & x));
    wire next_S1 = (~reset) & ((state == S0 & x) | (state == S1 & ~x) | 
                   (state == S2 & x) | (state == S3 & ~x));
    wire next_S2 = (~reset) & ((state == S2 & ~x) | (state == S3 & x) | 
                   (state == S4 & ~x));
    wire next_S3 = (~reset) & (state == S4 & ~x);
    wire next_S4 = (~reset) & ((state == S1 & x) | (state == S4 & x));

    // State registers with individual enables
    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
        end else begin
            state <= {next_S4, next_S3, next_S2, next_S1, next_S0};
        end
    end

    // Output logic - directly from state bits
    assign z = state[3] | state[4];  // S3 or S4 active

endmodule