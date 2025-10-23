module TopModule (
    input clk,
    input L,
    input q_in, // This input is not necessary based on the description
    input r_in,
    output reg Q
);

always @(posedge clk) begin
    if (L) begin
        Q <= r_in;
    end else begin
        // No need for any action when L is low, the flip-flop will retain its state
    end
end

endmodule