module TopModule (
    input clk,
    input reset,
    input slowena,
    output reg [3:0] q
);

    // One-hot state vector: 10 bits for states 0 to 9
    reg [9:0] state;

    // Update one-hot state
    always @(posedge clk) begin
        if (reset) begin
            state <= 10'b0000000001;  // state 0 active
        end else if (slowena) begin
            // rotate the one-hot bit to next position with wrap-around
            state <= {state[8:0], state[9]};
        end
        // else hold current state
    end

    // Combinational decoding from one-hot state to binary q
    always @(*) begin
        // default zero
        q = 4'd0;
        casez(state)
            10'b0000000001: q = 4'd0;
            10'b0000000010: q = 4'd1;
            10'b0000000100: q = 4'd2;
            10'b0000001000: q = 4'd3;
            10'b0000010000: q = 4'd4;
            10'b0000100000: q = 4'd5;
            10'b0001000000: q = 4'd6;
            10'b0010000000: q = 4'd7;
            10'b0100000000: q = 4'd8;
            10'b1000000000: q = 4'd9;
            default:       q = 4'd0; // safe fallback for invalid states
        endcase
    end

endmodule