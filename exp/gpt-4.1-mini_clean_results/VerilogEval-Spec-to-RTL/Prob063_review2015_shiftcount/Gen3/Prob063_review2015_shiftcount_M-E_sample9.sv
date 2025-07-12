module DFF (
    input clk,
    input d,
    output reg q
);
    always @(posedge clk) begin
        q <= d;
    end
endmodule

module TopModule (
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output [3:0] q
);
    // Internal register bits
    wire [3:0] q_int;
    reg init_reset = 1'b1; // Synchronous reset for initialization

    // On first clock, reset deasserts
    always @(posedge clk) begin
        init_reset <= 1'b0;
    end

    // Compute decremented value for q_int
    wire [3:0] q_val;
    reg [3:0] q_reg;

    // Hold previous state register
    always @(posedge clk) begin
        if (init_reset) begin
            q_reg <= 4'b0000;
        end else begin
            if (shift_ena) begin
                // Shift right by 1, insert data at MSB
                q_reg <= {data, q_reg[3:1]};
            end else if (count_ena) begin
                q_reg <= q_reg - 4'b0001;  // Wrap around naturally in 4 bits
            end else begin
                q_reg <= q_reg;
            end
        end
    end

    assign q = q_reg;

endmodule