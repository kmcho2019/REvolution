module sequence_detector (
    input  wire clk,
    input  wire reset_n,         // active low synchronous reset
    input  wire data_in,
    output reg  sequence_detected
);

    // State encoding (binary)
    localparam S0 = 3'd0; // no match
    localparam S1 = 3'd1; // detected '1'
    localparam S2 = 3'd2; // detected '10'
    localparam S3 = 3'd3; // detected '100'
    
    reg [2:0] state, next_state;

    // State transition logic (combinational)
    always @(*) begin
        case (state)
            S0: begin
                // Wait for first '1' of sequence
                if (data_in)
                    next_state = S1;
                else
                    next_state = S0;
            end
            S1: begin
                // Sequence is '1', next expected '0'
                if (!data_in)
                    next_state = S2;
                else
                    next_state = S1; // still '1', remain here for overlapping
            end
            S2: begin
                // Sequence is '10', next expected '0'
                if (!data_in)
                    next_state = S3;
                else
                    next_state = S0; // mismatch, back to start
            end
            S3: begin
                // Sequence is '100', next expected '1' to complete '1001'
                if (data_in)
                    next_state = S1; // output detected here, then since new '1', go S1 for overlap
                else
                    next_state = S0; // mismatch, back to start
            end
            default: next_state = S0;
        endcase
    end

    // State register with synchronous reset
    always @(posedge clk) begin
        if (!reset_n)
            state <= S0;
        else
            state <= next_state;
    end

    // Output logic: sequence_detected asserted when full sequence detected (on transition S3 + input=1)
    // Since output is Moore, assert when state is S3 and input=1 moves to S1 next cycle, detect now.
    always @(posedge clk) begin
        if (!reset_n)
            sequence_detected <= 1'b0;
        else
            sequence_detected <= (state == S3) && (data_in == 1'b1);
    end

endmodule