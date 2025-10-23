module parallel2serial (
    input wire clk,
    input wire rst_n,
    input wire [3:0] d,
    output reg valid_out,
    output reg dout
);

    reg [3:0] shift_reg;
    reg state;

    localparam LOAD = 1'b0;
    localparam SHIFT = 1'b1;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            shift_reg <= 4'b0;
            state <= LOAD;
            valid_out <= 1'b0;
            dout <= 1'b0;
        end else begin
            case (state)
                LOAD: begin
                    shift_reg <= d;
                    dout <= d[3];  // Output MSB first
                    valid_out <= 1'b1;
                    state <= SHIFT;
                end
                SHIFT: begin
                    shift_reg <= {shift_reg[2:0], 1'b0};  // Shift left
                    dout <= shift_reg[2];  // Next bit
                    valid_out <= 1'b0;
                    if (&shift_reg[2:0]) state <= LOAD;  // Detect when last bit is shifted
                end
            endcase
        end
    end

endmodule