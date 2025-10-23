module sequence_detector (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output reg  sequence_detected
);

    // State encoding using parameters to avoid enum typing issues
    localparam IDLE = 3'd0;
    localparam S1   = 3'd1; // matched '1'
    localparam S2   = 3'd2; // matched '10'
    localparam S3   = 3'd3; // matched '100'
    localparam S4   = 3'd4; // matched '1001'

    reg [2:0] state, next_state;

    // Next state logic combinational block
    always @(*) begin
        case (state)
            IDLE: next_state = data_in ? S1 : IDLE;
            S1:   next_state = data_in ? S1 : S2;
            S2:   next_state = data_in ? S1 : S3;
            S3:   next_state = data_in ? S4 : IDLE;
            S4:   next_state = data_in ? S1 : S2; // Allow overlapping sequences
            default: next_state = IDLE;
        endcase
    end

    // State and output update with synchronous active-low reset
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            sequence_detected <= 1'b0;
        end else begin
            state <= next_state;
            // sequence_detected asserted only on S4 state (detected sequence)
            sequence_detected <= (state == S4);
        end
    end

endmodule