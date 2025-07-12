module TopModule (
    input clk,
    input resetn,
    input in,
    output out
);

    reg [3:0] circular_reg;
    reg last_in;
    wire load_mode = (in != last_in);  // Detect input change for load mode

    always @(posedge clk) begin
        if (!resetn) begin
            circular_reg <= 4'b0;
            last_in <= 1'b0;
        end else begin
            last_in <= in;
            if (load_mode) begin
                // Parallel load - replicate input to all bits
                circular_reg <= {4{in}};
            end else begin
                // Circular shift right with LSB feeding back to MSB
                circular_reg <= {circular_reg[0], circular_reg[3:1]};
            end
        end
    end

    assign out = circular_reg[0];  // Output from LSB for circular behavior

endmodule