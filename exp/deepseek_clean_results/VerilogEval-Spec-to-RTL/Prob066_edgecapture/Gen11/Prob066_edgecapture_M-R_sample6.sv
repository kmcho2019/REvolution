module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output [31:0] out
);

    reg [31:0] prev_in;
    reg [31:0] current_in;
    reg [31:0] captured;

    // Output directly reflects captured state
    assign out = captured;

    always @(posedge clk) begin
        if (reset) begin
            prev_in <= 32'b0;
            current_in <= 32'b0;
            captured <= 32'b0;
        end
        else begin
            // Two-stage input pipeline
            prev_in <= current_in;
            current_in <= in;

            // Set capture bits on falling edges (prev=1, current=0)
            // Once set, bits stay set until reset
            captured <= captured | (prev_in & ~current_in);
        end
    end

endmodule