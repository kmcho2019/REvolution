module TopModule(
    input            clk,
    input            areset,
    input            load,
    input            ena,
    input      [3:0]  data,
    output reg [3:0]  q
);

always @(posedge clk or posedge areset) begin
    if(areset) begin
        q <= 4'd0; // Reset to zero on positive edge of areset
    end else begin
        if(load) begin
            q <= data; // Load data when load is high
        end else if(ena) begin
            q <= {1'b0, q[3:1]}; // Shift right when ena is high and load is not
        end
    end
end

endmodule