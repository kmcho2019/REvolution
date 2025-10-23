module TopModule (
    input         clk,
    input         load,
    input  [511:0] data,
    output reg [511:0] q
);
    // On each clock edge, either load the input data or compute next state
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            // Create extended vector with zero boundaries at both ends
            // q_ext[513] = 0 (left boundary), q_ext[0] = 0 (right boundary)
            // q_ext[512:1] = q[511:0]
            wire [513:0] q_ext;
            assign q_ext = {1'b0, q, 1'b0};

            // Compute next state: next_q[i] = q_ext[i+2] ^ q_ext[i]
            // i from 0 to 511
            integer i;
            reg [511:0] next_q;
            for (i = 0; i < 512; i = i + 1) begin
                next_q[i] = q_ext[i] ^ q_ext[i+2];
            end
            q <= next_q;
        end
    end
endmodule