module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

reg [2:0] next_q;

// On reset, initialize q to 4 for deterministic startup (optional)
// Since no reset input is specified in problem, we use initial block for simulation.
// For synthesis, consider adding reset if needed.
initial begin
    q = 3'd4;
end

// Combinational next state logic
always @(*) begin
    if (a) begin
        next_q = 3'd4; // Hold at 4 when a=1
    end else begin
        // Map q to modulo-7 counter starting at 4:
        // q states: 4->5->6->0->1->2->3->4
        // Represent this as q' = (q + 3) mod 7, increment, then map back.
        // To simplify, map q to an index 0..6:
        // index = (q + 3) mod 7
        // next index = (index + 1) mod 7
        // next_q = (next_index + 4) mod 7

        // Calculate index = (q + 3) mod 7
        // Since q and constants are small, manual modulo:
        // sum = q + 3;
        // If sum >=7, subtract 7
        // Then increment modulo 7 and map back

        integer index, next_index, mapped_q;

        index = q + 3;
        if (index >= 7)
            index = index - 7;
        next_index = index + 1;
        if (next_index >= 7)
            next_index = next_index -7;
        mapped_q = next_index + 4;
        if (mapped_q >=7)
            mapped_q = mapped_q -7;

        next_q = mapped_q[2:0];
    end
end

// Sequential update of q
always @(posedge clk) begin
    q <= next_q;
end

endmodule