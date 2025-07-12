module JC_counter (
    input  wire       clk,
    input  wire       rst_n,
    output reg [63:0] Q
);

integer i;
reg new_msb;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        Q <= 64'b0;
    end else begin
        new_msb = ~Q[0];
        // Explicitly shift right by one bit with non-blocking assignments
        // This makes the hardware shift behavior clear and synthesizable
        for (i = 0; i < 63; i = i + 1) begin
            Q[i] <= Q[i+1];
        end
        Q[63] <= new_msb;
    end
end

endmodule