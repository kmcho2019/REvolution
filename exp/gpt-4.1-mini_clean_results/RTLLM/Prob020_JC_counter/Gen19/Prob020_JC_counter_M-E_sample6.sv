module JC_counter (
    input  wire       clk,    // Clock signal for synchronous operation
    input  wire       rst_n,  // Asynchronous active-low reset
    output reg [63:0] Q       // 64-bit Johnson counter output
);

    wire feedback_bit;

    // feedback bit is inverted least significant bit of current Q
    assign feedback_bit = ~Q[0];

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            Q <= 64'b0; // Asynchronous reset to zero
        end else begin
            // Shift right and shift in feedback bit at MSB
            Q <= {feedback_bit, Q[63:1]};
        end
    end

endmodule