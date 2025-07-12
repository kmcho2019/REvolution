module TopModule (
    input        clk,
    input        reset,
    output reg [4:0] q
);

    // Compute the next state of the LFSR combinationally
    function [4:0] next_lfsr;
        input [4:0] current;
        reg feedback;
        begin
            feedback = current[0]; // output bit (LSB)
            // taps at bit 5 (q[4]) and bit 3 (q[2])
            next_lfsr[0] = current[1];
            next_lfsr[1] = current[2];
            next_lfsr[2] = current[3] ^ feedback;
            next_lfsr[3] = current[4];
            next_lfsr[4] = feedback ^ current[4];
        end
    endfunction

    always @(posedge clk) begin
        if (reset) begin
            q <= 5'b00001; // synchronous reset to 1
        end else begin
            q <= next_lfsr(q);
        end
    end

endmodule