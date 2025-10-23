module sequence_detector (
    input  wire clk,
    input  wire reset_n,        // active-low synchronous reset
    input  wire data_in,
    output reg  sequence_detected
);

    // One-hot state encoding
    localparam IDLE = 5'b00001;
    localparam S1   = 5'b00010;
    localparam S2   = 5'b00100;
    localparam S3   = 5'b01000;
    localparam S4   = 5'b10000;

    reg [4:0] state, next_state;

    // Next state logic (simplified combinational)
    always @(*) begin
        case (state)
            IDLE:    next_state = data_in ? S1 : IDLE;
            S1:      next_state = data_in ? S1 : S2;
            S2:      next_state = data_in ? S1 : S3;
            S3:      next_state = data_in ? S4 : IDLE;
            S4:      next_state = data_in ? S1 : IDLE;
            default: next_state = IDLE;
        endcase
    end

    // State register and output logic
    always @(posedge clk) begin
        if (!reset_n) begin
            state <= IDLE;
            sequence_detected <= 1'b0;
        end else begin
            state <= next_state;
            sequence_detected <= (next_state == S4);
        end
    end

endmodule