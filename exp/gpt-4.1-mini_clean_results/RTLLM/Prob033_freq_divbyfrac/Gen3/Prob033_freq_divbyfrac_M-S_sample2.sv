module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    localparam integer DIV_CYCLE = 7;

    reg [2:0] count;
    reg clk_int_a;
    reg clk_int_b;

    // Counter increments on posedge clk
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= 3'd0;
            clk_int_a <= 1'b0;
        end else begin
            if (count == DIV_CYCLE - 1)
                count <= 3'd0;
            else
                count <= count + 3'd1;

            // clk_int_a high for counts 0..3 (4 cycles), low 4..6 (3 cycles)
            clk_int_a <= (count < 4);
        end
    end

    // clk_int_b samples clk_int_a on negedge clk to create ~half-cycle phase shift
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            clk_int_b <= 1'b0;
        end else begin
            clk_int_b <= clk_int_a;
        end
    end

    // OR the two phase shifted intermediate clocks for fractional division
    assign clk_div = clk_int_a | clk_int_b;

endmodule