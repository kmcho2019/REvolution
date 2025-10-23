module TopModule(
    input clk,
    input areset,
    input x,
    output z
);

reg seen_one;  // flag to indicate if we've seen the first '1'
reg [1:0] state;  // state of the machine: 0-idle, 1-operating
reg carry;  // carry for the addition
reg out_bit;  // output bit

always @ (posedge clk or posedge areset) begin
    if (areset) begin
        seen_one <= 1'b0;
        state <= 2'b00;
        carry <= 1'b0;
        out_bit <= 1'b0;
    end else begin
        case (state)
            2'b00: begin  // idle state
                if (~areset) begin
                    state <= 2'b01;
                    seen_one <= 1'b0;
                    carry <= 1'b0;
                    out_bit <= 1'b0;
                end
            end
            2'b01: begin  // operating state
                if (x == 1'b1 && ~seen_one) begin
                    seen_one <= 1'b1;
                    out_bit <= ~x;
                end else if (seen_one) begin
                    out_bit <= ~x;
                    if (x == 1'b0 && carry == 1'b1) begin
                        out_bit <= 1'b1;
                    end
                    carry <= x & ~seen_one | carry & ~seen_one;
                end else begin
                    out_bit <= x;
                end
                if (areset) begin
                    state <= 2'b00;
                    seen_one <= 1'b0;
                    carry <= 1'b0;
                end
            end
        endcase
    end
end

always @ (*) begin
    if (state == 2'b01 && seen_one) begin
        if (x == 1'b1) begin
            z <= ~x;
        end else begin
            z <= ~x ^ carry;
        end
    end else begin
        z <= x;
    end
end

endmodule