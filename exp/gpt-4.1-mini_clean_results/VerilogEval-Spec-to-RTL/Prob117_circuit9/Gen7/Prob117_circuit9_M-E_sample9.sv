module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

wire [3:0] inc_val; // temporary wider to detect overflow

always @(posedge clk) begin
    if (a) begin
        q <= 3'd4; // Force q to 4 when a=1
    end else begin
        inc_val = q + 3'd1;  // increment q by 1
        if (inc_val == 4'd7) begin
            q <= 3'd0;      // wrap around modulo 7
        end else begin
            q <= inc_val[2:0];
        end
    end
end

endmodule