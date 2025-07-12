module TopModule (
    input clk,
    input reset,
    input data,
    output start_shifting
);

    // State encoding (2 bits for 3 states)
    localparam IDLE      = 2'b00;
    localparam SEARCHING = 2'b01;
    localparam FOUND     = 2'b10;

    reg [1:0] state;
    reg [2:0] shift_reg;  // Stores last 3 bits

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_reg <= 3'b0;
        end else begin
            case (state)
                IDLE: begin
                    shift_reg <= {shift_reg[1:0], data};
                    state <= (data) ? SEARCHING : IDLE;
                end
                SEARCHING: begin
                    shift_reg <= {shift_reg[1:0], data};
                    if (shift_reg == 3'b110 && data) begin
                        state <= FOUND;
                    end else if (!data && shift_reg[1:0] == 2'b00) begin
                        state <= IDLE;
                    end
                end
                FOUND: state <= FOUND;  // Stay in FOUND until reset
                default: state <= IDLE;
            endcase
        end
    end

    assign start_shifting = (state == FOUND);

endmodule