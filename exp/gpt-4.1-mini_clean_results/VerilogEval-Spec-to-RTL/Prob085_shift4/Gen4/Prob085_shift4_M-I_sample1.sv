module TopModule (
    input clk,
    input areset,
    input load,
    input ena,
    input [3:0] data,
    output reg [3:0] q
);

// Enable register update only when load or ena is asserted to reduce toggling
wire reg_en = load | ena;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        q <= 4'b0;
    end else if (reg_en) begin
        if (load) begin
            q <= data;
        end else begin
            q <= {1'b0, q[3:1]};
        end
    end
    // else hold current q to avoid unnecessary toggling
end

endmodule