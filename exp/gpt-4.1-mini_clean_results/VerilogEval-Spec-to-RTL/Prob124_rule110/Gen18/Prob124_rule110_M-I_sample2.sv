module TopModule (
    input  wire         clk,
    input  wire         load,
    input  wire [511:0] data,
    output reg  [511:0] q
);

    // Zero-padded extended vector for neighbor access
    wire [513:0] ext_q = {1'b0, q, 1'b0};

    wire [511:0] next_state;

    genvar i;
    generate
        for (i = 0; i < 512; i = i + 1) begin : rule110_update
            // Extract neighbors uniformly
            wire left   = ext_q[i+2];
            wire center = ext_q[i+1];
            wire right  = ext_q[i];
            // Rule 110 logic
            assign next_state[i] = (~left & center) | (center ^ right);
        end
    endgenerate

    // Clock enable: update only when load or next_state != q
    wire update_en = load | (next_state != q);

    always @(posedge clk) begin
        if (update_en) begin
            if (load) begin
                q <= data;
            end else begin
                q <= next_state;
            end
        end
    end

endmodule