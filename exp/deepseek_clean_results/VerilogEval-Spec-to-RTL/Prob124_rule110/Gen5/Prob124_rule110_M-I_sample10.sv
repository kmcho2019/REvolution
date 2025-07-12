module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Function implementing Rule 110 logic
    function automatic rule110;
        input left, center, right;
        begin
            case ({left, center, right})
                3'b111: rule110 = 0;
                3'b110: rule110 = 1;
                3'b101: rule110 = 1;
                3'b100: rule110 = 0;
                3'b011: rule110 = 1;
                3'b010: rule110 = 1;
                3'b001: rule110 = 1;
                3'b000: rule110 = 0;
            endcase
        end
    endfunction

    // Extended register for boundary handling
    reg [513:0] extended_q;
    wire [511:0] next_q;

    // Calculate next state in two pipeline stages
    genvar i;
    generate
        // First pipeline stage: bits 0-255
        for (i = 0; i < 256; i = i + 1) begin : stage1
            assign next_q[i] = rule110(extended_q[i+2], extended_q[i+1], extended_q[i]);
        end

        // Second pipeline stage: bits 256-511
        for (i = 256; i < 512; i = i + 1) begin : stage2
            assign next_q[i] = rule110(extended_q[i+2], extended_q[i+1], extended_q[i]);
        end
    endgenerate

    // Update extended register with boundary conditions
    always @(*) begin
        extended_q[0] = 0;
        extended_q[514:1] = {1'b0, q, 1'b0};
        extended_q[513] = 0;
    end

    // Clocked update with load and clock gating
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            // Only update bits that will change state
            for (integer j = 0; j < 512; j = j + 1) begin
                if (next_q[j] != q[j]) begin
                    q[j] <= next_q[j];
                end
            end
        end
    end

endmodule