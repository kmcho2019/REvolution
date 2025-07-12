module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Extend q with zero at MSB+1 and LSB-1 for uniform neighbor indexing
    wire [513:0] q_ext = {1'b0, q, 1'b0};

    wire [511:0] next_q;

    genvar i;
    generate
        for (i = 0; i < 512; i = i + 1) begin : rule110_next_state
            wire left   = q_ext[i+2];   // q[i+1] or 0 if out of range
            wire center = q_ext[i+1];   // q[i]
            wire right  = q_ext[i];     // q[i-1] or 0 if out of range
            // Rule 110 next state: (~left & center) | (center ^ right)
            assign next_q[i] = (~left & center) | (center ^ right);
        end
    endgenerate

    integer idx;
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            // Update only cells whose state changes to reduce switching
            for (idx = 0; idx < 512; idx = idx + 1) begin
                if (next_q[idx] != q[idx])
                    q[idx] <= next_q[idx];
                // else retain q[idx] to prevent toggling
            end
        end
    end

endmodule