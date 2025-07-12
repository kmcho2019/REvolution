module sequence_detector (
    input  wire clk,
    input  wire rst_n,           // active low synchronous reset
    input  wire data_in,
    output reg  sequence_detected
);

    // State encoding: binary codes for 5 states
    localparam IDLE = 3'd0,
               S1   = 3'd1,
               S2   = 3'd2,
               S3   = 3'd3,
               S4   = 3'd4;

    reg [2:0] state, next_state;

    // Synchronous state update with active-low reset
    always @(posedge clk) begin
        if (!rst_n)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Combinational next state logic for sequence "1001"
    always @(*) begin
        case (state)
            IDLE: next_state = data_in ? S1 : IDLE;
            S1:   next_state = (data_in == 1'b0) ? S2 : S1;          // After detecting '1', expect '0'
            S2:   next_state = (data_in == 1'b0) ? S3 : S1;          // After '10', expect '0' or restart if '1'
            S3:   next_state = data_in ? S4 : IDLE;                  // After '100', expect '1' for completion
            S4:   next_state = data_in ? S1 : IDLE;                  // Overlapping allowed, restart accordingly
            default: next_state = IDLE;
        endcase
    end

    // Output logic: assert sequence_detected for one cycle when entering S4
    always @(posedge clk) begin
        if (!rst_n)
            sequence_detected <= 1'b0;
        else
            sequence_detected <= (next_state == S4);
    end

endmodule