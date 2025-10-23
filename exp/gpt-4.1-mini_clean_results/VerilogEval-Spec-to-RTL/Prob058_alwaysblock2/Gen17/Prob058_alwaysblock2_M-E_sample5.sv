module TopModule (
    input  wire clk,
    input  wire a,
    input  wire b,
    output wire out_assign,
    output reg  out_always_comb,
    output reg  out_always_ff
);

    // Continuous assignment with direct behavioral XOR expression
    assign out_assign = a ^ b;

    // Combinational always_comb block explicitly performs XOR
    always @(*) begin
        out_always_comb = (a & ~b) | (~a & b);
    end

    // Registers inputs before computing XOR to add a stage of synchronization
    reg a_sync, b_sync;

    always @(posedge clk) begin
        a_sync <= a;
        b_sync <= b;
    end

    always @(posedge clk) begin
        // Compute XOR from registered inputs to produce out_always_ff
        out_always_ff <= a_sync ^ b_sync;
    end

endmodule