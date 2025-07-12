module TopModule (
    input clk,
    input areset,
    input load,
    input ena,
    input [3:0] data,
    output reg [3:0] q
);

always @(posedge clk or posedge areset) begin
    if (areset) begin
        q <= 4'b0000; // reset to zero
    end else begin
        if (load) begin
            q <= data; // load data
        end else if (ena) begin
            q <= {1'b0, q[3:1]}; // shift right
        end
    end
end

endmodule