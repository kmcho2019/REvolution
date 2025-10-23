module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    wire [511:0] next_q;
    wire [513:0] extended_q = {1'b0, q, 1'b0};  // Add virtual boundary bits

    // Rule 110 implementation using continuous assignments
    // For each bit, next state is:
    // (left && !(center && right)) || (!left && (center || right))
    // Which simplifies the original truth table
    genvar i;
    generate
        for (i = 0; i < 512; i = i + 1) begin : rule110
            assign next_q[i] = (extended_q[i+2] && !(extended_q[i+1] && extended_q[i])) || 
                              (!extended_q[i+2] && (extended_q[i+1] || extended_q[i]));
        end
    endgenerate

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_q;
        end
    end

endmodule