module parallel2serial (
    input wire clk,
    input wire rst_n,
    input wire [3:0] d,
    output reg valid_out,
    output reg dout
);

    reg [3:0] shift_reg;
    reg state;

    localparam IDLE = 1'b0;
    localparam SHIFTING = 1'b1;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            shift_reg <= 4'b0;
            state <= IDLE;
            valid_out <= 1'b0;
            dout <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    shift_reg <= d;
                    valid_out <= 1'b1;
                    dout <= d[3];
                    state <= SHIFTING;
                end
                SHIFTING: begin
                    shift_reg <= {shift_reg[2:0], 1'b0};  // Shift left
                    valid_out <= 1'b0;
                    dout <= shift_reg[2];  // Next bit is now in position [2]
                    
                    if (shift_reg[1:0] == 2'b00) begin  // Check if last bit
                        state <= IDLE;
                    end
                end
            endcase
        end
    end

endmodule