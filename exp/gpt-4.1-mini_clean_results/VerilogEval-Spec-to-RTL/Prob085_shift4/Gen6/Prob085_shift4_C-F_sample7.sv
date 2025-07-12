module TopModule (
    input        clk,
    input        areset,
    input        load,
    input        ena,
    input  [3:0] data,
    output reg [3:0] q
);

// Prepare shifted value with zero inserted at MSB
wire [3:0] shift_val = {1'b0, q[3:1]};

always @(posedge clk or posedge areset) begin
    if (areset) begin
        q <= 4'b0;  // asynchronous active-high reset, level-sensitive
    end else begin
        if (load) begin
            q <= data;      // load priority highest
        end else if (ena) begin
            q <= shift_val; // shift right with zero MSB
        end
        // else hold current q without redundant assignment
    end
end

endmodule