module sequence_detector (
    input  wire clk,
    input  wire reset_n,          // asynchronous active-low reset
    input  wire data_in,
    output reg  sequence_detected
);

    // State encoding (how many bits matched so far)
    localparam IDLE  = 3'b000;    // no bits matched yet
    localparam S1    = 3'b001;    // matched '1'
    localparam S10   = 3'b010;    // matched '10'
    localparam S100  = 3'b011;    // matched '100'

    reg [2:0] state, next_state;

    // State register with asynchronous active-low reset
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    // Next state logic (combinational)
    always @(*) begin
        case (state)
            IDLE: begin
                if (data_in)
                    next_state = S1;
                else
                    next_state = IDLE;
            end

            S1: begin
                if (!data_in)
                    next_state = S10;    // matched "10"
                else
                    next_state = S1;     // '1' again, stay in S1
            end

            S10: begin
                if (!data_in)
                    next_state = S100;   // matched "100"
                else
                    next_state = S1;     // '1' detected, start over at S1
            end

            S100: begin
                if (data_in)
                    next_state = S1;     // after detection, possible overlapping starts here
                else
                    next_state = IDLE;
            end

            default: next_state = IDLE;
        endcase
    end

    // Output logic (Mealy): sequence_detected asserted when in S100 and data_in=1 (completes "1001")
    always @(*) begin
        sequence_detected = (state == S100) && (data_in == 1'b1);
    end

endmodule