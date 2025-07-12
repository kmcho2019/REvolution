module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Function implementing Rule 110 logic
    function rule110;
        input left, center, right;
        begin
            case ({left, center, right})
                3'b000: rule110 = 0;
                3'b001: rule110 = 1;
                3'b010: rule110 = 1;
                3'b011: rule110 = 1;
                3'b100: rule110 = 0;
                3'b101: rule110 = 1;
                3'b110: rule110 = 1;
                3'b111: rule110 = 0;
                default: rule110 = 0;
            endcase
        end
    endfunction

    reg [511:0] next_q;
    integer i;

    always @(*) begin
        // Process internal bits (1 to 510)
        for (i = 1; i < 511; i = i + 1) begin
            next_q[i] = rule110(q[i+1], q[i], q[i-1]);
        end

        // Left boundary (bit 0)
        next_q[0] = rule110(q[1], q[0], 1'b0);
        
        // Right boundary (bit 511)
        next_q[511] = rule110(1'b0, q[511], q[510]);
    end

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_q;
        end
    end

endmodule