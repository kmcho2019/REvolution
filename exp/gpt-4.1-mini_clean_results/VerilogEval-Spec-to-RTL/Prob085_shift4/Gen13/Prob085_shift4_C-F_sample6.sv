module TopModule (
    input        clk,
    input        areset,
    input        load,
    input        ena,
    input  [3:0] data,
    output reg [3:0] q
);

// Combinational logic to select next state based on priority signals
wire [3:0] shifted_q = {1'b0, q[3:1]};

always @(posedge clk or posedge areset) begin
    if (areset) begin
        q <= 4'b0;                 // Asynchronous reset
    end else if (load) begin
        q <= data;                 // Load has highest synchronous priority
    end else if (ena) begin
        q <= shifted_q;            // Shift right with zero fill MSB
    end
    // else hold current q (no assignment needed)
end

endmodule