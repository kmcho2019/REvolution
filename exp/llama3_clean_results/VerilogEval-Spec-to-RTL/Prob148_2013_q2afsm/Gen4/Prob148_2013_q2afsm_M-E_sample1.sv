module TopModule (
    input  clk,
    input  resetn,
    input  [2:0] r,
    output [2:0] g
);

// Priority encoder
reg [1:0] priority;

always @(*) begin
    if (r[0] == 1'b1) begin
        priority = 2'b00;  // Device 0 has highest priority
    end else if (r[1] == 1'b1) begin
        priority = 2'b01;  // Device 1 has next highest priority
    end else if (r[2] == 1'b1) begin
        priority = 2'b10;  // Device 2 has lowest priority
    end else begin
        priority = 2'b11;  // No devices requesting
    end
end

// Output signals
always @(*) begin
    case (priority)
        2'b00: begin
            g[0] = 1'b1;  // Grant to device 0
            g[1] = 1'b0;
            g[2] = 1'b0;
        end
        2'b01: begin
            g[0] = 1'b0;
            g[1] = 1'b1;  // Grant to device 1
            g[2] = 1'b0;
        end
        2'b10: begin
            g[0] = 1'b0;
            g[1] = 1'b0;
            g[2] = 1'b1;  // Grant to device 2
        end
        default: begin
            g[0] = 1'b0;
            g[1] = 1'b0;
            g[2] = 1'b0;  // No grants
        end
    endcase
end

endmodule