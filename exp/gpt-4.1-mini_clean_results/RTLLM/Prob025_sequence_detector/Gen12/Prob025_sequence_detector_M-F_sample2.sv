module sequence_detector (
    input  wire clk,
    input  wire rst_n,       // Rename reset input to match testbench
    input  wire data_in,
    output reg  sequence_detected
);

    // Binary encoding of states
    localparam IDLE = 3'd0,
               S1   = 3'd1,
               S2   = 3'd2,
               S3   = 3'd3,
               S4   = 3'd4;

    reg [2:0] state, next_state;

    // State register with synchronous active-low reset
    always @(posedge clk) begin
        if (!rst_n)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Next state logic (combinational)
    always @(*) begin
        case (state)
            IDLE: next_state = data_in ? S1 : IDLE;
            S1:   next_state = (data_in == 1'b0) ? S2 : S1;  // Allow overlapping detection
            S2:   next_state = (data_in == 1'b0) ? S3 : IDLE;
            S3:   next_state = data_in ? S4 : IDLE;
            S4:   next_state = data_in ? S1 : IDLE;          // Overlapping sequences allowed
            default: next_state = IDLE;
        endcase
    end

    // Output logic: one-cycle pulse when sequence 1001 detected
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            sequence_detected <= 1'b0;
        else
            sequence_detected <= (state == S3) && (data_in == 1'b1);
    end

endmodule