module TopModule (
    input clk,
    input x,
    output z
);

    // Flip-flop outputs
    reg xor_ff;
    reg and_ff;
    reg or_ff;

    // Combinational logic for each path
    wire xor_path = x ^ xor_ff;
    wire and_path = x & (~and_ff);
    wire or_path = x | (~or_ff);

    // Sequential logic - separate always blocks for clarity
    always @(posedge clk) begin
        xor_ff <= xor_path;
    end

    always @(posedge clk) begin
        and_ff <= and_path;
    end

    always @(posedge clk) begin
        or_ff <= or_path;
    end

    // Output logic
    assign z = ~(xor_ff | and_ff | or_ff);

    // Initialization (synthesis-friendly)
    initial begin
        xor_ff = 1'b0;
        and_ff = 1'b0;
        or_ff = 1'b0;
    end

endmodule