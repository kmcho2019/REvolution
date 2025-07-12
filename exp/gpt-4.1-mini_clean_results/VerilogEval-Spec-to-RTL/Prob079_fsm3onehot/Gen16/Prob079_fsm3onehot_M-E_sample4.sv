module TopModule (
    input        in,
    input  [3:0] state,
    output reg [3:0] next_state,
    output reg       out
);

    always @(*) begin
        // Default assignments to avoid inferred latches
        next_state = 4'b0000;
        out = 1'b0;
        
        // Combine state and input for case analysis
        casez ({state, in})
            // State A=0001
            5'b0001_0: begin next_state = 4'b0001; out = 0; end // Stay A
            5'b0001_1: begin next_state = 4'b0010; out = 0; end // Go B

            // State B=0010
            5'b0010_0: begin next_state = 4'b0100; out = 0; end // Go C
            5'b0010_1: begin next_state = 4'b0010; out = 0; end // Stay B

            // State C=0100
            5'b0100_0: begin next_state = 4'b0001; out = 0; end // Go A
            5'b0100_1: begin next_state = 4'b1000; out = 0; end // Go D

            // State D=1000
            5'b1000_0: begin next_state = 4'b0100; out = 1; end // Go C, output=1
            5'b1000_1: begin next_state = 4'b0010; out = 1; end // Go B, output=1

            // Default safe state (optional)
            default: begin next_state = 4'b0000; out = 0; end
        endcase
    end

endmodule