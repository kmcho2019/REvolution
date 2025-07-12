module TopModule (
    input clk,
    input in,
    output out
);

    reg q;  // Flip-flop state storage
    wire next_state;  // Combinational XOR result

    // Combinational XOR logic
    assign next_state = in ^ q;

    // Sequential flip-flop
    always @(posedge clk) begin
        q <= next_state;
    end

    assign out = q;

endmodule