module TopModule(
    input clk,
    input a,
    output reg [2:0] q
);

// Initialize the output
initial q = 4;

// Combinational logic to generate the next state of the counter
reg [2:0] next_q;

always @(*) begin
    if (a) begin
        // Reset to 4 when a is high
        next_q = 3'b100;
    end else begin
        // Increment q when a is low, wrapping around from 6 to 0
        if (q == 6) begin
            next_q = 0;
        end else begin
            next_q = q + 1;
        end
    end
end

// Sequential logic to update the counter
always @(posedge clk) begin
    q <= next_q;
end

endmodule