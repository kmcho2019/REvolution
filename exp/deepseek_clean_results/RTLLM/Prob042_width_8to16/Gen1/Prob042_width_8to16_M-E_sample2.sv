module width_8to16 (
    input wire clk,
    input wire rst_n,
    input wire valid_in,
    input wire [7:0] data_in,
    
    output reg valid_out,
    output reg [15:0] data_out
);

// State machine states
typedef enum logic [1:0] {
    IDLE,
    FIRST_BYTE,
    OUTPUT
} state_t;

reg [1:0] state, next_state;
reg [15:0] shift_reg;
reg [1:0] byte_counter;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
        shift_reg <= 16'b0;
        byte_counter <= 2'b0;
        data_out <= 16'b0;
        valid_out <= 1'b0;
    end
    else begin
        state <= next_state;
        
        // Default outputs
        valid_out <= 1'b0;
        
        // State machine actions
        case (state)
            IDLE: begin
                if (valid_in) begin
                    shift_reg <= {8'b0, data_in};
                    byte_counter <= 2'b1;
                end
            end
            
            FIRST_BYTE: begin
                if (valid_in) begin
                    shift_reg <= {shift_reg[7:0], data_in};
                    byte_counter <= byte_counter + 1;
                end
            end
            
            OUTPUT: begin
                data_out <= shift_reg;
                valid_out <= 1'b1;
                byte_counter <= 2'b0;
                
                // Preload next byte if available
                if (valid_in) begin
                    shift_reg <= {8'b0, data_in};
                    byte_counter <= 2'b1;
                end
            end
        endcase
    end
end

// Next state logic
always_comb begin
    next_state = state;
    case (state)
        IDLE: if (valid_in) next_state = FIRST_BYTE;
        FIRST_BYTE: if (byte_counter == 2) next_state = OUTPUT;
        OUTPUT: next_state = (valid_in) ? FIRST_BYTE : IDLE;
        default: next_state = IDLE;
    endcase
end

endmodule