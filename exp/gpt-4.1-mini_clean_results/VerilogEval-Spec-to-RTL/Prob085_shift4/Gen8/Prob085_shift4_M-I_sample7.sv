module TopModule (
    input        clk,
    input        areset,
    input        load,
    input        ena,
    input  [3:0] data,
    output reg [3:0] q
);

// Shift right: MSB gets 0, others shift right
wire [3:0] shift_val = {1'b0, q[3:1]};

always @(posedge clk or posedge areset) begin
    if (areset) begin
        q <= 4'b0;  // asynchronous reset, level-sensitive
    end else if (load) begin
        q <= data;  // load has highest priority
    end else if (ena) begin
        q <= shift_val; // shift right with zero fill at MSB
    end
    // else hold current value implicitly
end

endmodule