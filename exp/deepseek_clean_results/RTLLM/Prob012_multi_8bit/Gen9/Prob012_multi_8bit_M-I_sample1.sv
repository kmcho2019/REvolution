module multi_8bit(
    input clk,
    input reset,
    input [7:0] A,
    input [7:0] B,
    output reg [15:0] product
);

    reg [2:0] bit_counter;
    reg [15:0] shifted_A;
    reg [15:0] partial_sum;
    reg [15:0] next_partial_sum;
    wire [15:0] shifted_A_next;
    wire add_enable;

    // Clock gating for power optimization
    assign add_enable = B[bit_counter] & ~reset;

    // Shifted A calculation
    assign shifted_A_next = {8'b0, A} << bit_counter;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            bit_counter <= 3'b0;
            shifted_A <= 16'b0;
            partial_sum <= 16'b0;
            product <= 16'b0;
        end else begin
            if (bit_counter == 3'b0) begin
                // Initialize on first cycle
                shifted_A <= {8'b0, A};
                partial_sum <= 16'b0;
            end else begin
                shifted_A <= shifted_A_next;
                partial_sum <= next_partial_sum;
            end

            if (bit_counter == 3'd7) begin
                // Final result
                product <= next_partial_sum;
                bit_counter <= 3'b0;
            end else begin
                bit_counter <= bit_counter + 1;
            end
        end
    end

    // Carry-save adder implementation
    always @(*) begin
        if (add_enable)
            next_partial_sum = partial_sum + shifted_A;
        else
            next_partial_sum = partial_sum;
    end

endmodule