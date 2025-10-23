module up_down_counter #(
    parameter WIDTH = 16
) (
    input clk,
    input reset,
    input up_down,
    output reg [WIDTH-1:0] count
);

// Gray code conversion
wire [WIDTH-1:0] gray_count;
assign gray_count = count ^ {1'b0, count[WIDTH-1:1]};

// Carry-select adder implementation
reg [3:0] count_lsb;
reg [WIDTH-5:0] count_msb;
wire [3:0] next_lsb;
wire [WIDTH-5:0] next_msb;
wire carry_out;

// LSB 4-bit counter with carry
always @(posedge clk) begin
    if (reset) begin
        count_lsb <= 4'b0;
    end else begin
        if (up_down) begin
            {carry_out, next_lsb} = count_lsb + 1'b1;
        end else begin
            {carry_out, next_lsb} = count_lsb - 1'b1;
        end
        count_lsb <= next_lsb;
    end
end

// MSB counter with carry in
always @(posedge clk) begin
    if (reset) begin
        count_msb <= {(WIDTH-4){1'b0}};
    end else begin
        if (up_down) begin
            count_msb <= count_msb + carry_out;
        end else begin
            count_msb <= count_msb - carry_out;
        end
    end
end

// Final output assignment with clock gating
always @(posedge clk) begin
    if (reset) begin
        count <= {WIDTH{1'b0}};
    end else begin
        count <= {count_msb, count_lsb};
    end
end

endmodule