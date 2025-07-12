module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Function to compute Rule 110 for a given center and neighbors
    function rule110;
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

    // Temporary extended register for boundary handling
    reg [513:0] q_ext;
    reg [511:0] next_q;

    // Process in 8 parallel pipelines of 64 bits each
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : pipeline
            integer j;
            always @(*) begin
                for (j = 0; j < 64; j = j + 1) begin
                    // Calculate with boundary zeros
                    q_ext = {1'b0, q, 1'b0};
                    // Only update if state will change (implicit clock gating)
                    if (next_q[i*64 + j] != q[i*64 + j]) begin
                        next_q[i*64 + j] = rule110(
                            q_ext[i*64 + j + 2],  // left neighbor
                            q_ext[i*64 + j + 1],  // center
                            q_ext[i*64 + j]       // right neighbor
                        );
                    end
                end
            end
        end
    endgenerate

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_q;
        end
    end

    // Initialize next_q to current q (only changes will propagate)
    initial begin
        next_q = q;
    end

endmodule