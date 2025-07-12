module parallel2serial (
    input wire clk,
    input wire rst_n,
    input wire [3:0] d,
    output wire valid_out,
    output wire dout
);

    // State encoding
    localparam LOAD = 1'b0;
    localparam SHIFT = 1'b1;
    
    reg state;
    reg [3:0] shift_reg;
    
    // Continuous assignments
    assign dout = shift_reg[3];  // Always output MSB
    assign valid_out = (state == LOAD);  // Valid when in LOAD state
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= LOAD;
            shift_reg <= 4'b0;
        end else begin
            case (state)
                LOAD: begin
                    shift_reg <= d;
                    state <= SHIFT;
                end
                SHIFT: begin
                    shift_reg <= {shift_reg[2:0], 1'b0};
                    if (&shift_reg[2:0])  // Detect when we've shifted 3 times
                        state <= LOAD;
                end
            endcase
        end
    end

endmodule