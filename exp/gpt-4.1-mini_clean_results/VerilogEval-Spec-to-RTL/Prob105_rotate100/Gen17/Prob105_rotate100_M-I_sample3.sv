module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

    // Clock enable asserted only when loading or rotating
    wire clk_en = load || (ena == 2'b01) || (ena == 2'b10);

    always @(posedge clk) begin
        if (clk_en) begin
            if (load) begin
                // Synchronously load input data
                q <= data;
            end else begin
                case (ena)
                    2'b01: 
                        // Rotate right by one: LSB becomes MSB
                        q <= {q[0], q[99:1]};
                    2'b10: 
                        // Rotate left by one: MSB becomes LSB
                        q <= {q[98:0], q[99]};
                    default: 
                        // No rotation, keep q unchanged (redundant due to clk_en)
                        q <= q;
                endcase
            end
        end
        // When clk_en==0, q holds value automatically (no clock enable == no update)
    end

endmodule