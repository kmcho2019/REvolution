module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

reg [511:0] next_q; // Temporary array to store next states

always @(posedge clk) begin
    if (load) begin
        q <= data;
    end else begin
        for (int i = 0; i < 512; i++) begin
            reg left, center, right;
            if (i == 0) begin
                left = 0;
            end else begin
                left = q[i-1];
            end
            center = q[i];
            if (i == 511) begin
                right = 0;
            end else begin
                right = q[i+1];
            end
            
            case ({left, center, right})
                3'b111: next_q[i] = 0;
                3'b110: next_q[i] = 1;
                3'b101: next_q[i] = 1;
                3'b100: next_q[i] = 0;
                3'b011: next_q[i] = 1;
                3'b010: next_q[i] = 1;
                3'b001: next_q[i] = 1;
                3'b000: next_q[i] = 0;
                default: next_q[i] = q[i];
            endcase
        end
        q <= next_q; // Update q with calculated next states
    end
end

endmodule