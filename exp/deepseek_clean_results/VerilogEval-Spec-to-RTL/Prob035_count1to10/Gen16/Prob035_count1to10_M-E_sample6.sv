module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 4'b0001;  // Initialize to position 1
    end
    else begin
        case (q)
            4'b1010: q <= 4'b0001;  // After 10, wrap to 1
            default: begin
                // Circular shift with forced transitions
                if (q[0]) q <= {1'b1, 3'b000};
                else q <= {1'b0, q[3:1]};
            end
        endcase
    end
end

endmodule