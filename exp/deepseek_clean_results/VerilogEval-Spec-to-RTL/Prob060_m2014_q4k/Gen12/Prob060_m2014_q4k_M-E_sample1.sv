module TopModule (
    input clk,
    input resetn,
    input in,
    output out
);

    reg [3:0] shift_reg;
    reg [1:0] head_ptr;
    reg load_mode;

    // Output is always the oldest bit (head position)
    assign out = shift_reg[head_ptr];

    always @(posedge clk) begin
        if (!resetn) begin
            shift_reg <= 4'b0;
            head_ptr <= 2'b0;
            load_mode <= 1'b0;
        end
        else begin
            if (load_mode) begin
                // Parallel load mode (though not used in this simple version)
                shift_reg <= {in, in, in, in};
                head_ptr <= 2'b0;
            end
            else begin
                // Circular shift mode
                shift_reg[head_ptr] <= in;
                head_ptr <= head_ptr + 1;
            end
        end
    end

endmodule