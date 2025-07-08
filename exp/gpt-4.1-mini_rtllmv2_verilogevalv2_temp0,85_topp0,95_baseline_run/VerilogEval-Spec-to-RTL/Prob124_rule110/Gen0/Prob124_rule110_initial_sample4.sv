module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    integer i;
    reg [511:0] next_state;

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            // Compute next state for each cell
            for (i = 0; i < 512; i = i + 1) begin
                // Define neighbors with boundary zeros
                // Left neighbor is q[i+1], except for i=511 -> 0
                // Center is q[i]
                // Right neighbor is q[i-1], except for i=0 -> 0
                // Because indexing: left means i+1, right means i-1
                
                // Assign neighbors safely
                reg left, center, right;
                left = (i == 511) ? 1'b0 : q[i+1];
                center = q[i];
                right = (i == 0) ? 1'b0 : q[i-1];

                // Apply Rule 110:
                // Next state = 0 when 111 or 100 or 000
                // Next state = 1 otherwise
                // We can encode the rule as:
                // Concatenate {left,center,right} to a 3-bit number and use a case statement or direct logic
                
                case ({left, center, right})
                    3'b111: next_state[i] = 1'b0;
                    3'b110: next_state[i] = 1'b1;
                    3'b101: next_state[i] = 1'b1;
                    3'b100: next_state[i] = 1'b0;
                    3'b011: next_state[i] = 1'b1;
                    3'b010: next_state[i] = 1'b1;
                    3'b001: next_state[i] = 1'b1;
                    3'b000: next_state[i] = 1'b0;
                    default: next_state[i] = 1'b0; // just in case
                endcase
            end
            q <= next_state;
        end
    end

endmodule