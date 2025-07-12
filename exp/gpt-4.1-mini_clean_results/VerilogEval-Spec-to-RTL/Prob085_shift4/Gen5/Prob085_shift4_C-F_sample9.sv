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
wire [3:0] load_val = data;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        q <= 4'b0;  // asynchronous reset active high, level-sensitive
    end else begin
        if (load) begin
            q <= load_val;
        end else if (ena) begin
            q <= shift_val;
        end
        // else hold current q without redundant self-assignment
    end
end

endmodule