module TopModule(
    input  clk,
    input  areset,
    input  x,
    output z
);

reg [1:0] state; // 0 - idle, 1 - conversion
reg [31:0] num; // input number
reg [31:0] twos_comp; // 2's complement
reg carry; // carry bit
reg [4:0] bit_count; // bit count

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 0;
        num <= 0;
        twos_comp <= 0;
        carry <= 0;
        bit_count <= 0;
        z <= 0;
    end
    else begin
        case(state)
            0: begin
                if (~areset) begin
                    state <= 1;
                end
            end
            1: begin
                num[0] <= x;
                for (int i = 1; i < 32; i++) begin
                    num[i] <= num[i-1];
                end
                if (~x) begin
                    carry <= 1;
                end
                if (carry) begin
                    if (~x) begin
                        z <= 1;
                    end
                    else begin
                        z <= 0;
                    end
                end
                else begin
                    z <= ~x;
                end
                bit_count <= bit_count + 1;
                if (areset) begin
                    state <= 0;
                end
            end
        endcase
    end
end

endmodule