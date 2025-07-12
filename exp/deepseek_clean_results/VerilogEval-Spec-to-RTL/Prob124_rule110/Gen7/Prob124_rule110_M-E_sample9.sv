module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Combinational next state calculation
    wire [511:0] next_q;

    // Boundary bits (treated separately for clarity)
    assign next_q[0] = (q[0] & ~q[1]) ? 1'b1 : (~q[0] & q[1]) ? 1'b1 : 1'b0;
    assign next_q[511] = (q[510] & q[511]) ? 1'b1 : (~q[510] & q[511]) ? 1'b1 : 1'b0;

    // Main processing using sliding window
    genvar i;
    generate
        for (i = 1; i < 511; i = i + 1) begin : rule110_window
            // Sliding 3-bit window
            wire [2:0] window = {q[i+1], q[i], q[i-1]};
            
            // Rule 110 lookup table
            always @(*) begin
                case (window)
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

    // State transition logic
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_q;
        end
    end

endmodule