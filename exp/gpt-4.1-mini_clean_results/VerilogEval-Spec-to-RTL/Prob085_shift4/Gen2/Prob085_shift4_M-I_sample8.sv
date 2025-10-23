module TopModule (
    input clk,
    input areset,
    input load,
    input ena,
    input [3:0] data,
    output reg [3:0] q
);

wire write_enable = load | ena;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        q <= 4'b0000;
    end else if (write_enable) begin
        if (load) begin
            q <= data;
        end else begin
            q <= {1'b0, q[3:1]};
        end
    end
    // else q holds its previous value implicitly
end

endmodule