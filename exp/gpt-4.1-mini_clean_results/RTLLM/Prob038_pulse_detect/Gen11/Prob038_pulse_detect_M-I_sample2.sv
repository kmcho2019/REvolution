module pulse_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output reg  data_out
);

    // One-hot state encoding
    localparam S0 = 3'b001; // waiting for 0 (start)
    localparam S1 = 3'b010; // got 0, waiting for 1
    localparam S2 = 3'b100; // got 1 after 0, waiting for 0 to complete pulse

    reg [2:0] state, next_state;

    // Combinational next state logic
    always @(*) begin
        case (state)
            S0: next_state = (data_in == 1'b0) ? S1 : S0;
            S1: next_state = (data_in == 1'b1) ? S2 : S1;
            S2: next_state = (data_in == 1'b0) ? S0 : S2;
            default: next_state = S0;
        endcase
    end

    // Sequential logic: update state and generate output
    always @(posedge clk) begin
        if (!rst_n) begin
            state    <= S0;
            data_out <= 1'b0;
        end else begin
            // Assert data_out only at the cycle pulse completes: from S2 to S0 transition
            data_out <= (state == S2 && next_state == S0) ? 1'b1 : 1'b0;
            state    <= next_state;
        end
    end

endmodule