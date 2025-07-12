module TopModule (
    input        clk,
    input        areset,
    input        load,
    input        ena,
    input  [3:0] data,
    output reg [3:0] q
);

// Sequential logic with asynchronous reset and priority load > ena > hold
always @(posedge clk or posedge areset) begin
    if (areset) begin
        q <= 4'b0000;
    end else begin
        if (load) begin
            q <= data;
        end else if (ena) begin
            // Right shift with zero fill at MSB
            q[3] <= 1'b0;
            q[2] <= q[3];
            q[1] <= q[2];
            q[0] <= q[1];
        end else begin
            // Hold current state
            q <= q;
        end
    end
end

endmodule