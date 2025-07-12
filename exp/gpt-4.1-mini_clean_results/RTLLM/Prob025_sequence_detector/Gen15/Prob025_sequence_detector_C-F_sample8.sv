module sequence_detector (
    input  wire clk,
    input  wire rst_n,           // Active-low synchronous reset, renamed for common convention
    input  wire data_in,
    output reg  sequence_detected
);

    // State encoding (binary)
    localparam IDLE = 2'b00,
               S1   = 2'b01,
               S2   = 2'b10,
               S3   = 2'b11;

    reg [1:0] state, next_state;

    // State register with synchronous active-low reset
    always @(posedge clk) begin
        if (!rst_n)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Next-state logic
    always @(*) begin
        case (state)
            IDLE: next_state = data_in ? S1 : IDLE;   // Wait for '1'
            S1:   next_state = data_in ? S1 : S2;     // Expect '0'; if '1', stay in S1 for overlapping
            S2:   next_state = data_in ? S3 : IDLE;   // Expect '0' or '1'; '1' advances to S3, else restart
            S3:   next_state = data_in ? S1 : S2;     // On input '1', sequence detected; allow overlaps
            default: next_state = IDLE;
        endcase
    end

    // Output logic: sequence_detected asserted 1 clk cycle when sequence "1001" detected
    // Detection occurs when in state S3 and input bit is '1' (completing the sequence)
    always @(posedge clk) begin
        if (!rst_n)
            sequence_detected <= 1'b0;
        else
            sequence_detected <= (state == S3) && (data_in == 1'b1);
    end

endmodule