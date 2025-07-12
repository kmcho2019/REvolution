module multi_16bit (
    input clk,
    input rst_n,
    input start,
    input [15:0] ain,
    input [15:0] bin,
    output reg [31:0] yout,
    output done
);

reg [4:0] i;            // Counter (0-16)
reg [15:0] areg, breg;  // Operand registers
reg [31:0] acc;         // Accumulator
reg done_r;             // Done flag

assign done = done_r;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset all registers
        i <= 5'b0;
        areg <= 16'b0;
        breg <= 16'b0;
        acc <= 32'b0;
        done_r <= 1'b0;
    end
    else begin
        case (i)
            5'd0: begin
                // Initial state
                done_r <= 1'b0;
                if (start) begin
                    // Load operands and start
                    areg <= ain;
                    breg <= bin;
                    acc <= 32'b0;
                    i <= i + 1;
                end
            end
            5'd1, 5'd2, 5'd3, 5'd4, 5'd5, 5'd6, 5'd7, 5'd8,
            5'd9, 5'd10, 5'd11, 5'd12, 5'd13, 5'd14, 5'd15: begin
                // Active computation cycles
                if (breg[i-1]) begin
                    acc <= acc + (areg << (i-1));
                end
                i <= i + 1;
            end
            5'd16: begin
                // Final computation cycle
                if (breg[15]) begin
                    acc <= acc + (areg << 15);
                end
                done_r <= 1'b1;
                i <= i + 1;
            end
            default: begin
                // Hold state (i = 17+)
                done_r <= 1'b0;
                if (!start) begin
                    i <= 5'b0;  // Reset counter when start goes low
                end
            end
        endcase
    end
end

// Direct output assignment
always @(*) begin
    yout = acc;
end

endmodule