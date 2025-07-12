module pulse_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output reg  data_out
);

    // State encoding
    localparam S0 = 2'd0; // Wait for initial 0
    localparam S1 = 2'd1; // Got 0, wait for 1
    localparam S2 = 2'd2; // Got 1, wait for final 0 (pulse end)

    reg [1:0] state, next_state;

    // Next state and pulse detection combinational logic
    always @(*) begin
        case (state)
            S0: next_state = (data_in == 1'b0) ? S1 : S0;
            S1: next_state = (data_in == 1'b1) ? S2 : S1;
            S2: next_state = (data_in == 1'b0) ? S1 : S2;
            default: next_state = S0;
        endcase
    end

    // State update and output generation in one sequential block
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state    <= S0;
            data_out <= 1'b0;
        end else begin
            state <= next_state;
            // Assert data_out when pulse completes: when current state is S2 and data_in is 0
            // Because next_state = S1 in that condition, pulse detected on this cycle
            data_out <= (state == S2 && data_in == 1'b0);
        end
    end

endmodule