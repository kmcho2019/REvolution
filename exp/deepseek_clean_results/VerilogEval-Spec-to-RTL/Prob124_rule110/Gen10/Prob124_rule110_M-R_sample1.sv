module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Create padded version of q with boundary conditions
    wire [513:0] padded_q = {1'b0, q, 1'b0};

    // Calculate next state for all bits in parallel
    wire [511:0] next_q;
    
    // Apply Rule 110 to each bit using the padded vector
    assign next_q[511:0] = (padded_q[512:1] ^ padded_q[510:0]) | 
                          (~padded_q[513:2] & (padded_q[512:1] | padded_q[510:0]));

    // State transition logic
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_q;
        end
    end

endmodule