module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Extend q with zero padding at boundaries for uniform neighbor indexing
    wire [513:0] q_ext = {1'b0, q, 1'b0};

    wire [511:0] next_q;

    genvar i;
    generate
        for (i = 0; i < 512; i = i + 1) begin : rule110_next_state
            wire left   = q_ext[i+2];
            wire center = q_ext[i+1];
            wire right  = q_ext[i];
            // Rule 110 next state boolean expression
            assign next_q[i] = (~left & center) | (center ^ right);
        end
    endgenerate

    // Create a load enable mask: either load whole data or selectively update bits where next_q != q
    wire [511:0] load_mask = {512{load}};
    wire [511:0] update_mask = (load) ? {512{1'b1}} : (next_q ^ q);

    // Register update: update only bits where load or next_q differs to reduce toggling
    // This is a classic clock gating simulation pattern using enable signals per bit
    integer idx;
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            // Update only bits that changed to reduce switching
            // Note: synthesis tools usually do not support bit-wise clock gating directly,
            // so we implement conditional update with masking
            for (idx = 0; idx < 512; idx = idx + 1) begin
                if (update_mask[idx])
                    q[idx] <= next_q[idx];
                // else retain previous q[idx]
            end
        end
    end

endmodule