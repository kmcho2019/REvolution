module TopModule (
  input clk,
  input a,
  output reg [2:0] q
);

reg a_prev;
reg [1:0] a_stable_count;

always @ (posedge clk) begin
    // Detect positive edge of 'a'
    if (a == 1'b1 && a_prev == 1'b0) begin
        if (q < 3'd6)
            q <= q + 1;
    end
    a_prev <= a;

    // Counter reset condition
    if (a == 1'b0)
        a_stable_count <= a_stable_count + 1;
    else
        a_stable_count <= 2'b00;
    
    // Reset counter to 0 when 'a' is continuously 0 for 3 clock cycles
    if (a_stable_count == 2'd3)
        q <= 3'b000;
end

initial begin
    a_prev <= 1'b1;
    a_stable_count <= 2'b00;
    q <= 3'bxxx; // Initial value of q is unknown
end

endmodule