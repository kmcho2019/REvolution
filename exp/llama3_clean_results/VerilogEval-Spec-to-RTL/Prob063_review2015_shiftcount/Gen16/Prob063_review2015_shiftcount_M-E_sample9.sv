module TopModule(
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output [3:0] q
);

reg [3:0] q_reg;
reg [1:0] state;

// Define the states
localparam SHIFT = 2'b00;
localparam COUNT = 2'b01;

always @(posedge clk) begin
    case (state)
        SHIFT: begin
            if (shift_ena) begin
                // Shift in the new data bit into the least significant bit position
                q_reg <= {q_reg[2:0], data};
            end
            if (count_ena) begin
                state <= COUNT;
            end
        end
        COUNT: begin
            if (count_ena) begin
                // Decrement operation
                q_reg <= q_reg - 1;
            end
            if (shift_ena) begin
                state <= SHIFT;
            end
        end
        default: begin
            state <= SHIFT;
            q_reg <= 4'b0;
        end
    endcase
end

assign q = q_reg;

initial begin
    state <= SHIFT;
    q_reg <= 4'b0;
end

endmodule