module multi_pipe_4bit #(
    parameter size = 4
)(
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

reg [size-1:0] multiplier_reg;
reg [2*size-1:0] partial_product_reg [size-1:0];
reg [2*size-1:0] accumulated_sum_reg;
reg [2*size-1:0] temp;
reg [1:0] counter;

// State machine
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        counter <= 2'b00;
        accumulated_sum_reg <= {2*size{1'b0}};
    end else begin
        case (counter)
            2'b00: begin
                multiplier_reg <= mul_b;
                counter <= 2'b01;
            end
            2'b01: begin
                if (multiplier_reg == {size{1'b0}}) begin
                    counter <= 2'b10;
                end else begin
                    counter <= 2'b01;
                end
            end
            2'b10: begin
                counter <= 2'b00;
            end
            default: begin
                counter <= 2'b00;
            end
        endcase
    end
end

// Partial product generation stage
always @(posedge clk) begin
    for (int i = 0; i < size; i++) begin
        if (multiplier_reg[i] == 1'b1) begin
            temp = {mul_a, {size{1'b0}}};
            partial_product_reg[i] <= temp << i;
        end else begin
            partial_product_reg[i] <= {2*size{1'b0}};
        end
    end
end

// Accumulation stage
always @(posedge clk) begin
    if (counter == 2'b10) begin
        accumulated_sum_reg <= {2*size{1'b0}};
        for (int i = 0; i < size; i++) begin
            accumulated_sum_reg <= accumulated_sum_reg + partial_product_reg[i];
        end
        mul_out <= accumulated_sum_reg;
    end
end

endmodule