module signal_generator (
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg [31:0] pattern;
reg direction; // 0=right, 1=left

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        pattern <= 32'h00000001;
        direction <= 1'b0;
    end else begin
        // Shift based on direction
        if (direction) begin
            pattern <= {pattern[30:0], pattern[31]};
        end else begin
            pattern <= {pattern[0], pattern[31:1]};
        end
        
        // Auto-reverse direction at boundaries
        if (pattern[31] && !direction) begin
            direction <= 1'b1;
        end else if (pattern[0] && direction) begin
            direction <= 1'b0;
        end
    end
end

// Output is the position of the '1' in the pattern
always @(*) begin
    casez (pattern)
        32'b1???????????????????????????????: wave = 5'd31;
        32'b01??????????????????????????????: wave = 5'd30;
        32'b001?????????????????????????????: wave = 5'd29;
        // ... pattern continues for all positions ...
        32'b0000000000000000000000000000001: wave = 5'd0;
        default: wave = 5'd0;
    endcase
end

endmodule