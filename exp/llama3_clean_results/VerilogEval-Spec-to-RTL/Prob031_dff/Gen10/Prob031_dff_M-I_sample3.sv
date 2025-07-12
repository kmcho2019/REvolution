module TopModule(
    input clk,
    input rst_n, // Asynchronous reset
    input d,
    output reg q
);

// Attribute to specify a target clock period for optimization
// Adjust this value according to the synthesis tool and design requirements
(* max_freq = "1000.0" *) 

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset the flip-flop to 0 upon reset assertion
        q <= 1'b0;
    end else begin
        // Non-blocking assignment for clarity and potential expansion
        q <= d;
    end
end

endmodule