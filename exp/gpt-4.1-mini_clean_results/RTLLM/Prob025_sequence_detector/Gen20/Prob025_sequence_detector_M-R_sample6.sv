module sequence_detector (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output reg  sequence_detected
);

    // State encoding (same as original)
    localparam IDLE = 3'b000,
               S1   = 3'b001,
               S2   = 3'b011,
               S3   = 3'b010,
               S4   = 3'b110;

    reg [2:0] state;

    // Function to compute next state based on current state and data_in
    function [2:0] next_state_f;
        input [2:0] curr_state;
        input       bit_in;
        begin
            case (curr_state)
                IDLE: next_state_f = bit_in ? S1   : IDLE;
                S1:   next_state_f = bit_in ? S1   : S2;
                S2:   next_state_f = bit_in ? S1   : S3;
                S3:   next_state_f = bit_in ? S4   : IDLE;
                S4:   next_state_f = bit_in ? S1   : IDLE;
                default: next_state_f = IDLE;
            endcase
        end
    endfunction

    // Sequential state register update with synchronous active-low reset
    always @(posedge clk) begin
        if (!rst_n)
            state <= IDLE;
        else
            state <= next_state_f(state, data_in);
    end

    // Registered output logic for stable Moore output
    always @(posedge clk) begin
        if (!rst_n)
            sequence_detected <= 1'b0;
        else
            sequence_detected <= (state == S4);
    end

endmodule