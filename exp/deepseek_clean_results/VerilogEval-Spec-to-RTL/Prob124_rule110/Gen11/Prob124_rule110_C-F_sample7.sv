module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    wire [511:0] next_q;
    genvar i;

    generate
        for (i = 0; i < 512; i = i + 1) begin : rule110_gen
            // Optimized neighbor selection with shared boundary logic
            wire left = (i == 511) ? 1'b0 : q[i+1];
            wire right = (i == 0) ? 1'b0 : q[i-1];
            
            // Compact Rule 110 implementation
            always @(*) begin
                case ({left, q[i], right})
                    3'b111: next_q[i] = 1'b0;
                    3'b110: next_q[i] = 1'b1;
                    3'b101: next_q[i] = 1'b1;
                    3'b100: next_q[i] = 1'b0;
                    3'b011: next_q[i] = 1'b1;
                    3'b010: next_q[i] = 1'b1;
                    3'b001: next_q[i] = 1'b1;
                    3'b000: next_q[i] = 1'b0;
                endcase
            end
        end
    endgenerate

    // Simplified state transition without conditional update
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_q;
        end
    end

endmodule