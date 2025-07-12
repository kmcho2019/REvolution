module TopModule (
    input clk,
    input in,
    output out
);

    reg q;  // Flip-flop state
    wire d; // D input to flip-flop

    // XOR operation - combinational logic
    assign d = in ^ q;

    // D flip-flop - sequential logic
    always @(posedge clk) begin
        q <= d;
    end

    // Output assignment
    assign out = q;

endmodule