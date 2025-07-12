module sequence_detector (
    input  wire clk,
    input  wire reset_n,          // synchronous active-low reset
    input  wire data_in,
    output reg  sequence_detected
);

    // State encoding: number of bits matched in sequence "1001"
    localparam IDLE  = 3'b000;    // no bits matched
    localparam S1    = 3'b001;    // matched '1'
    localparam S10   = 3'b010;    // matched "10"
    localparam S100  = 3'b011;    // matched "100"

    reg [2:0] state, next_state;

    // State register with synchronous active-low reset
    always @(posedge clk) begin
        if (!reset_n)
            state <= IDLE;
        else
            state <= next_state;
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
                    next_state = S10;
                else
                    next_state = S1;
            end

            S10: begin
                if (!data_in)
                    next_state = S100;
                else
                    next_state = S1;
            end

            S100: begin
                // Sequence "100" matched, next bit determines detection and next state
                if (data_in)
                    next_state = S1;   // possible start of overlapping sequence
                else
                    next_state = IDLE;
            end

            default: next_state = IDLE;
        endcase
    end

    // Output logic: registered pulse for one clock cycle when sequence "1001" detected
    always @(posedge clk) begin
        if (!reset_n)
            sequence_detected <= 1'b0;
        else
            // Assert when current state is S100 and input bit completes "1001"
            sequence_detected <= (state == S100) && (data_in == 1'b1);
    end

endmodule