module TopModule (
    input         clk,
    input         areset,
    input         load,
    input         ena,
    input  [3:0]  data,
    output reg [3:0] q
);

// Asynchronous reset handled in a separate always block
always @(posedge areset or posedge clk) begin
    if (areset) begin
        q <= 4'b0;
    end else begin
        // On clock edge when not reset:
        if (load) begin
            q <= data;
        end else if (ena) begin
            q <= {1'b0, q[3:1]};
        end
        // else hold q
    end
end

endmodule