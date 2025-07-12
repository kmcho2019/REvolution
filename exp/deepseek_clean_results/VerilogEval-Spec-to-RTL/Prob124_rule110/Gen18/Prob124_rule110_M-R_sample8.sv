module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Compute next state using bitwise operations
    wire [511:0] next_q = (q ^ ({1'b0, q[511:1]} & {q[510:0], 1'b0})) | 
                         (~{1'b0, q[511:1]} & {q[510:0], 1'b0});

    // Update state on clock edge
    always @(posedge clk) begin
        q <= load ? data : next_q;
    end

endmodule