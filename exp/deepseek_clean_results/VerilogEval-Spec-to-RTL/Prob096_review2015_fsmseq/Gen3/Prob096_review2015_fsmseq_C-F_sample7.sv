module TopModule (
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

    reg [2:0] shift_reg;
    reg [1:0] state;

    // State encoding
    localparam IDLE  = 2'b00;
    localparam GOT1  = 2'b01;
    localparam GOT11 = 2'b10;
    localparam FOUND = 2'b11;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_reg <= 3'b0;
            start_shifting <= 1'b0;
        end else if (!start_shifting) begin
            shift_reg <= {shift_reg[1:0], data};
            
            case (state)
                IDLE:  state <= (data) ? GOT1 : IDLE;
                GOT1:  state <= (data) ? GOT11 : IDLE;
                GOT11: begin
                    if (shift_reg == 3'b101 && data) begin
                        state <= FOUND;
                        start_shifting <= 1'b1;
                    end else begin
                        state <= (data) ? GOT11 : IDLE;
                    end
                end
                default: state <= IDLE;
            endcase
        end
    end

endmodule