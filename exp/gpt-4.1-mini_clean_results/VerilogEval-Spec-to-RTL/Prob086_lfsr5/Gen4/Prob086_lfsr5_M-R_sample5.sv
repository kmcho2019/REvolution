module TopModule(
    input clk,
    input reset,
    output reg [4:0] q
);

// Function to compute the next state of the LFSR
function [4:0] lfsr_next;
    input [4:0] current;
    reg feedback;
begin
    feedback = current[0];
    lfsr_next[0] = current[1];
    lfsr_next[1] = current[2];
    lfsr_next[2] = current[3] ^ feedback; // tap at bit 3
    lfsr_next[3] = current[4];
    lfsr_next[4] = feedback;              // tap at bit 5
end
endfunction

always @(posedge clk) begin
    if (reset) begin
        q <= 5'b00001;
    end else begin
        q <= lfsr_next(q);
    end
end

endmodule