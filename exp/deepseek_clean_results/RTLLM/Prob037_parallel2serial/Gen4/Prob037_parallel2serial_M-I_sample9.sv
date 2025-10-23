module parallel2serial (
    input wire clk,
    input wire rst_n,
    input wire [3:0] d,
    output reg valid_out,
    output reg dout
);

    reg [3:0] shift_reg;
    reg load;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            shift_reg <= 4'b0;
            valid_out <= 1'b0;
            dout <= 1'b0;
            load <= 1'b1;  // Start by loading new data
        end else begin
            if (load) begin
                // Load new data and output MSB
                shift_reg <= d;
                dout <= d[3];
                valid_out <= 1'b1;
                load <= 1'b0;
            end else begin
                // Shift out remaining bits
                shift_reg <= {shift_reg[2:0], 1'b0};
                dout <= shift_reg[2];
                valid_out <= 1'b0;
                // Set load when we've output all 4 bits
                if (&shift_reg[2:0]) begin
                    load <= 1'b1;
                end
            end
        end
    end

endmodule