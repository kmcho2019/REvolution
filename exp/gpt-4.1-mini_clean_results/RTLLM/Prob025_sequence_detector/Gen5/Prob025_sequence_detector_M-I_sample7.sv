module sequence_detector (
    input  wire clk,
    input  wire reset,       // synchronous active-high reset
    input  wire data_in,
    output reg  sequence_detected
);

    // State encoding using localparams for synthesis compatibility
    localparam IDLE  = 3'b000; // Waiting for first '1'
    localparam S1    = 3'b001; // matched '1'
    localparam S10   = 3'b010; // matched '10'
    localparam S100  = 3'b011; // matched '100'
    localparam S1001 = 3'b100; // matched '1001' (final detection)

    reg [2:0] state, next_state;

    // Next state combinational logic
    always @(*) begin
        case (state)
            IDLE: begin
                if (data_in)       // if input bit is 1, go to S1
                    next_state = S1;
                else
                    next_state = IDLE;
            end

            S1: begin
                if (!data_in)      // input 0, advance to S10 (matched "10")
                    next_state = S10;
                else               // input 1, stay in S1 (possible overlapping sequence)
                    next_state = S1;
            end

            S10: begin
                if (!data_in)      // input 0, advance to S100 (matched "100")
                    next_state = S100;
                else               // input 1, restart sequence detection from S1
                    next_state = S1;
            end

            S100: begin
                if (data_in)       // input 1, sequence "1001" matched
                    next_state = S1001;
                else               // input 0, no match, reset to IDLE
                    next_state = IDLE;
            end

            S1001: begin
                // Sequence detected; check input for overlapping sequences
                if (data_in)
                    next_state = S1;
                else
                    next_state = IDLE;
            end

            default: next_state = IDLE;
        endcase
    end

    // State register and output logic, synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            sequence_detected <= 1'b0;
        end else begin
            state <= next_state;
            // Assert output one cycle when state moves into S1001
            sequence_detected <= (next_state == S1001);
        end
    end

endmodule