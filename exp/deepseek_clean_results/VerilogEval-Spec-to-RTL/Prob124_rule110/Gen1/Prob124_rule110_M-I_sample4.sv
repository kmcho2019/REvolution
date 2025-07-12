module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    reg [511:0] next_q;

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_q;
        end
    end

    always @(*) begin
        // Left boundary (q[-1] = 0)
        next_q[0] = rule110(1'b0, q[0], q[1]);
        
        // Middle cells
        for (integer i = 1; i < 511; i = i + 1) begin
            next_q[i] = rule110(q[i-1], q[i], q[i+1]);
        end
        
        // Right boundary (q[512] = 0)
        next_q[511] = rule110(q[510], q[511], 1'b0);
    end

    // Rule 110 logic function
    function rule110;
        input left, center, right;
        begin
            case ({left, center, right})
                3'b111: rule110 = 1'b0;
                3'b110: rule110 = 1'b1;
                3'b101: rule110 = 1'b1;
                3'b100: rule110 = 1'b0;
                3'b011: rule110 = 1'b1;
                3'b010: rule110 = 1'b1;
                3'b001: rule110 = 1'b1;
                3'b000: rule110 = 1'b0;
                default: rule110 = 1'b0;
            endcase
        end
    endfunction

endmodule