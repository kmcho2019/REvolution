module TopModule (
    input  clk,
    input  L,
    input  q_in,
    input  r_in,
    output reg Q
);

    // Calculate next D input directly in always block
    // Add clock enable to reduce toggling:
    // Flip-flop updates when L=1 (load) or when input would change (q_in != r_in)
    wire ce = L | (q_in != r_in);

    always @(posedge clk) begin
        if (ce) begin
            Q <= L ? r_in : q_in;
        end
    end

endmodule