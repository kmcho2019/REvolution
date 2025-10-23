module TopModule (
    input        clk,
    input        areset,
    input        load,
    input        ena,
    input  [3:0] data,
    output reg [3:0] q
);

reg [3:0] next_q;

// Combinational logic to determine next state
always @(*) begin
    // Priority: load > ena > hold
    if (load) begin
        next_q = data;
    end else if (ena) begin
        // Right shift using shift operator with zero fill
        next_q = q >> 1;
    end else begin
        // Hold current value
        next_q = q;
    end
end

// Sequential logic with asynchronous positive-edge reset
always @(posedge clk or posedge areset) begin
    if (areset)
        q <= 4'b0;
    else
        q <= next_q;
end

endmodule