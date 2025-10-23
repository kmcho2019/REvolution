module TopModule(
    input clk,
    input d,
    input rst_n, // Asynchronous active-low reset
    output reg q
);

// Attribute to specify a target clock period for optimization
(* max_freq = "1000.0" *) 

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset condition: Set q to 0 when rst_n is low
        q <= 1'b0;
    end else begin
        // For a basic D flip-flop, the implementation remains straightforward.
        q <= d;
    end
end

endmodule