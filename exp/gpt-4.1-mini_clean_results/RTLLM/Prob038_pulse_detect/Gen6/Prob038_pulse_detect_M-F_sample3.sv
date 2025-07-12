module pulse_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output reg  data_out
);

    // State encoding
    localparam S0 = 2'd0; // Wait for first 0
    localparam S1 = 2'd1; // Got 0, wait for 1
    localparam S2 = 2'd2; // Got 1, wait for 0 (pulse end)

    reg [1:0] state, next_state;
    wire pulse_detected;

    // Next state logic
    always @(*) begin
        case (state)
            S0: next_state = (data_in == 1'b0) ? S1 : S0;
            S1: next_state = (data_in == 1'b1) ? S2 : S1;
            S2: next_state = (data_in == 1'b0) ? S1 : S2;
            default: next_state = S0;
        endcase
    end

    // Pulse detected combinational signal: when in S2 and data_in is 0 (pulse completes)
    assign pulse_detected = (state == S2) && (data_in == 1'b0);

    // Sequential logic: state update and registered output
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state    <= S0;
            data_out <= 1'b0;
        end else begin
            state <= next_state;
            data_out <= pulse_detected ? 1'b1 : 1'b0;
        end
    end

endmodule