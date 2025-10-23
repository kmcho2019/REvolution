module JC_counter (
    input  wire       clk,     // Clock input
    input  wire       rst_n,   // Active-low asynchronous reset
    output reg [63:0] Q        // 64-bit Johnson counter output
);

    integer i;
    reg new_msb;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            Q <= 64'b0;        // Reset counter to zero
        end else begin
            new_msb = ~Q[0];   // Invert LSB for new MSB insertion
            // Shift right by one bit with nonblocking assignments
            for (i = 0; i < 63; i = i + 1) begin
                Q[i] <= Q[i + 1];
            end
            Q[63] <= new_msb;  // Assign new MSB
        end
    end

endmodule