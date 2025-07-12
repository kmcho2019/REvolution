module TopModule (
    input clk,
    input reset,
    output reg shift_ena
);

    reg [3:0] shift_pattern;
    reg [1:0] shift_count;
    
    always @(posedge clk) begin
        if (reset) begin
            shift_pattern <= 4'b1111;
            shift_count <= 2'b00;
            shift_ena <= 1'b1;
        end else begin
            if (shift_count < 2'b11) begin
                shift_pattern <= {shift_pattern[2:0], 1'b0};
                shift_count <= shift_count + 1;
                shift_ena <= shift_pattern[3];
            end else begin
                shift_ena <= 1'b0;  // Stay low after 4 cycles
            end
        end
    end

endmodule