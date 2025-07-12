module TopModule (
    input clk,
    input resetn,
    input in,
    output out
);

    reg [3:0] circular_reg;
    reg [1:0] pos_counter;

    always @(posedge clk) begin
        if (!resetn) begin
            circular_reg <= 4'b0;
            pos_counter <= 2'b0;
        end
        else begin
            // Circular shift
            circular_reg <= {circular_reg[2:0], in};
            
            // Increment position counter (mod 4)
            pos_counter <= pos_counter + 1;
        end
    end

    // Output selection based on counter
    assign out = circular_reg[pos_counter];

endmodule