module sequence_detector (
    input  wire clk,
    input  wire rst_n,           // Active-low synchronous reset
    input  wire data_in,
    output wire sequence_detected
);

    // Optimized state encoding (3 bits), arranged to reduce bit toggling:
    // IDLE=3'b000, S1=3'b001, S2=3'b011, S3=3'b010, S4=3'b110
    localparam IDLE = 3'b000,
               S1   = 3'b001,
               S2   = 3'b011,
               S3   = 3'b010,
               S4   = 3'b110;

    reg [2:0] state, next_state;

    // Combinational next-state logic
    always @(*) begin
        case (state)
            IDLE: next_state = data_in ? S1 : IDLE;
            S1:   next_state = data_in ? S1 : S2;
            S2:   next_state = data_in ? S1 : S3;
            S3:   next_state = data_in ? S4 : IDLE;
            S4:   next_state = data_in ? S1 : IDLE;
            default: next_state = IDLE;
        endcase
    end

    // Sequential state register with synchronous active-low reset
    always @(posedge clk) begin
        if (!rst_n)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Combinational output logic (Moore output)
    assign sequence_detected = (state == S4);

endmodule