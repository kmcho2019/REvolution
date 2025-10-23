module sequence_detector (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output wire sequence_detected
);

    // State encoding using parameters
    localparam IDLE = 3'd0;
    localparam S1   = 3'd1; // matched '1'
    localparam S2   = 3'd2; // matched '10'
    localparam S3   = 3'd3; // matched '100'
    localparam S4   = 3'd4; // matched '1001' - detection complete

    reg [2:0] state, next_state;

    // Next state logic combinational block
    always @(*) begin
        case (state)
            IDLE: next_state = data_in ? S1 : IDLE;
            S1:   next_state = data_in ? S1 : S2;
            S2:   next_state = data_in ? S1 : S3;
            S3:   next_state = data_in ? S4 : IDLE;
            S4:   next_state = data_in ? S1 : S2; // allow overlapping sequences
            default: next_state = IDLE;
        endcase
    end

    // State update with synchronous active-low reset
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Output logic combinational: assert sequence_detected when next state is S4
    assign sequence_detected = (next_state == S4);

endmodule