module sequence_detector (
    input  wire clk,
    input  wire reset_n,           // synchronous active-low reset
    input  wire data_in,
    output reg  sequence_detected
);

    // Binary encoding of FSM states
    localparam IDLE = 3'b000,
               S1   = 3'b001,
               S2   = 3'b010,
               S3   = 3'b011,
               S4   = 3'b100;

    reg [2:0] state, next_state;

    // Next state combinational logic
    always @(*) begin
        case(state)
            IDLE:  next_state = data_in ? S1 : IDLE;
            S1:    next_state = (data_in == 1'b0) ? S2 : S1;
            S2:    next_state = (data_in == 1'b0) ? S3 : IDLE;
            S3:    next_state = (data_in == 1'b1) ? S4 : IDLE;
            S4:    next_state = data_in ? S1 : IDLE;
            default: next_state = IDLE;
        endcase
    end

    // State register and output logic synchronous with clk and synchronous reset
    always @(posedge clk) begin
        if (!reset_n) begin
            state <= IDLE;
            sequence_detected <= 1'b0;
        end else begin
            state <= next_state;
            // sequence_detected asserted for 1 clock cycle when entering S4
            sequence_detected <= (next_state == S4);
        end
    end

endmodule