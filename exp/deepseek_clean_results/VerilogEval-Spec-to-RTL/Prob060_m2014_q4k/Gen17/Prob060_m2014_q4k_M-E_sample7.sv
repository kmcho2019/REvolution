module TopModule (
    input clk,
    input resetn,
    input in,
    output out
);

    reg [3:0] shift_reg;
    reg [1:0] pattern_counter;
    
    always @(posedge clk) begin
        if (!resetn) begin
            shift_reg <= 4'b0;
            pattern_counter <= 2'b0;
        end
        else begin
            // Detect 4 consecutive 1's to trigger parallel load
            if (in) begin
                if (pattern_counter == 2'b11) begin
                    shift_reg <= shift_reg; // Circular load
                    pattern_counter <= 2'b0;
                end
                else begin
                    pattern_counter <= pattern_counter + 1;
                    shift_reg <= {shift_reg[2:0], in}; // Normal shift
                end
            end
            else begin
                pattern_counter <= 2'b0;
                shift_reg <= {shift_reg[2:0], in}; // Normal shift
            end
        end
    end

    assign out = shift_reg[3];

endmodule