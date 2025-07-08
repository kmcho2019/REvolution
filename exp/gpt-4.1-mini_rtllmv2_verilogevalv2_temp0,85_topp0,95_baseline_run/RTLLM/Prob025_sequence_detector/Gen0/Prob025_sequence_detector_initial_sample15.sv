module sequence_detector (
    input  wire clk,
    input  wire reset_n,
    input  wire data_in,
    output reg  sequence_detected
);

    // State encoding using localparams for clarity
    localparam IDLE = 3'd0,
               S1   = 3'd1,
               S2   = 3'd2,
               S3   = 3'd3,
               S4   = 3'd4;

    reg [2:0] state, next_state;

    // State transition logic (combinational)
    always @(*) begin
        case(state)
            IDLE: begin
                if (data_in == 1'b1)
                    next_state = S1;    // first bit '1' detected
                else
                    next_state = IDLE;
            end

            S1: begin
                if (data_in == 1'b0)
                    next_state = S2;    // second bit '0' detected
                else if (data_in == 1'b1)
                    next_state = S1;    // restart at S1 because input is '1'
                else
                    next_state = IDLE;
            end

            S2: begin
                if (data_in == 1'b0)
                    next_state = IDLE;  // sequence broken, restart
                else if (data_in == 1'b1)
                    next_state = S3;    // third bit '0' failed here, must be '0', if '1' restart?
                else
                    next_state = IDLE;
            end

            S3: begin
                if (data_in == 1'b1)
                    next_state = S4;    // fourth bit '1' detected, sequence complete
                else if (data_in == 1'b0)
                    next_state = S2;    // partial overlap, check if this '0' starts new partial seq
                else
                    next_state = IDLE;
            end

            S4: begin
                // After detection, check if next bit can start new sequence
                if (data_in == 1'b1)
                    next_state = S1;
                else
                    next_state = IDLE;
            end

            default: next_state = IDLE;
        endcase
    end

    // State register update
    always @(posedge clk or negedge reset_n) begin
        if (~reset_n)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Output logic (Moore machine output)
    always @(posedge clk or negedge reset_n) begin
        if (~reset_n)
            sequence_detected <= 1'b0;
        else
            sequence_detected <= (state == S4);
    end

endmodule