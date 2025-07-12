module width_8to16 (
    input wire clk,
    input wire rst_n,
    input wire valid_in,
    input wire [7:0] data_in,
    
    output reg valid_out,
    output reg [15:0] data_out
);

// FSM states
typedef enum logic [1:0] {
    IDLE,
    FIRST_BYTE,
    OUTPUT
} state_t;

reg [1:0] state, next_state;
reg [15:0] shift_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
        shift_reg <= 16'b0;
        data_out <= 16'b0;
        valid_out <= 1'b0;
    end
    else begin
        state <= next_state;
        valid_out <= 1'b0;
        
        case (state)
            IDLE: begin
                if (valid_in) begin
                    shift_reg <= {8'b0, data_in};
                    next_state <= FIRST_BYTE;
                end
            end
            
            FIRST_BYTE: begin
                if (valid_in) begin
                    shift_reg <= {shift_reg[7:0], data_in};
                    next_state <= OUTPUT;
                end
            end
            
            OUTPUT: begin
                data_out <= shift_reg;
                valid_out <= 1'b1;
                next_state <= IDLE;
            end
            
            default: next_state <= IDLE;
        endcase
    end
end

endmodule