module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

    reg [0:99] shift_reg;

    integer i;
    always @(posedge clk) begin
        if (load) begin
            // Load data into the circular shift register
            for (i = 0; i < 100; i = i + 1) begin
                shift_reg[i] <= data[i];
            end
        end else begin
            case (ena)
                2'b01: begin // Rotate right by 1
                    for (i = 0; i < 100; i = i + 1) begin
                        // Each flip-flop takes from left neighbor with wrap-around
                        shift_reg[i] <= shift_reg[(i == 0) ? 99 : i - 1];
                    end
                end
                2'b10: begin // Rotate left by 1
                    for (i = 0; i < 100; i = i + 1) begin
                        // Each flip-flop takes from right neighbor with wrap-around
                        shift_reg[i] <= shift_reg[(i == 99) ? 0 : i + 1];
                    end
                end
                default: begin
                    // No rotation, retain values
                    for (i = 0; i < 100; i = i + 1) begin
                        shift_reg[i] <= shift_reg[i];
                    end
                end
            endcase
        end
    end

    // Assign shift register contents to output
    always @(*) begin
        for (i = 0; i < 100; i = i + 1) begin
            q[i] = shift_reg[i];
        end
    end

endmodule