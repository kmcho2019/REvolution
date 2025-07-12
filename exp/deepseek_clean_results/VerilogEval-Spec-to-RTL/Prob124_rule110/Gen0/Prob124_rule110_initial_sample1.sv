module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            // Compute next state for each cell
            q[0] <= rule110(1'b0, q[0], q[1]);    // Left boundary (q[-1] = 0)
            q[511] <= rule110(q[510], q[511], 1'b0); // Right boundary (q[512] = 0)
            
            for (integer i = 1; i < 511; i = i + 1) begin
                q[i] <= rule110(q[i-1], q[i], q[i+1]);
            end
        end
    end

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