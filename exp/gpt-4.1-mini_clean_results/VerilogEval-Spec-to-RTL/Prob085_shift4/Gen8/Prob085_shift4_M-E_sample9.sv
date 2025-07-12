module TopModule (
    input        clk,
    input        areset,
    input        load,
    input        ena,
    input  [3:0] data,
    output reg [3:0] q
);

// Asynchronous active-high reset with level sensitivity
always @(posedge clk or posedge areset) begin
    if (areset) begin
        q <= 4'b0000;
    end else if (load) begin
        q <= data;  // load data
    end else if (ena) begin
        // Right shift with MSB zero fill
        q[0] <= q[1];
        q[1] <= q[2];
        q[2] <= q[3];
        q[3] <= 1'b0;
    end
    // else retain current q
end

endmodule