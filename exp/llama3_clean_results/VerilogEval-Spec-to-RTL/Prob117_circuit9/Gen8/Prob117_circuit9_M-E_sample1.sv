module TopModule(
    input clk,
    input a,
    output reg [2:0] q
);

// Internal signal to hold the next state
reg [2:0] next_q;

// Combinational logic to determine the next state
always @(*) begin
    if (a) begin
        // If 'a' is high, force 'q' to '4'
        next_q = 3'b100;
    end else begin
        // If 'a' is low, increment 'q' unless it's '6', then wrap around to '0'
        if (q == 3'b110) begin
            next_q = 3'b000;
        end else begin
            next_q = q + 1'b1;
        end
    end
end

// Sequential logic to update 'q' at each positive clock edge
always @(posedge clk) begin
    q <= next_q;
end

// Initialize 'q' to '4' at the start
initial q = 3'b100;

endmodule