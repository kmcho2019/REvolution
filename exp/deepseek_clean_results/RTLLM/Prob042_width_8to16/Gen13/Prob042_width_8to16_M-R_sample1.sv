module width_8to16 (
    input wire clk,
    input wire rst_n,
    input wire valid_in,
    input wire [7:0] data_in,
    
    output reg valid_out,
    output reg [15:0] data_out
);

// State definitions
parameter IDLE = 1'b0;
parameter HAS_FIRST_BYTE = 1'b1;

reg state, next_state;
reg [7:0] first_byte;

// State transition logic
always @(*) begin
    next_state = state;
    case (state)
        IDLE: if (valid_in) next_state = HAS_FIRST_BYTE;
        HAS_FIRST_BYTE: if (valid_in) next_state = IDLE;
    endcase
end

// Sequential logic for state and data
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
        first_byte <= 8'b0;
        data_out <= 16'b0;
        valid_out <= 1'b0;
    end else begin
        state <= next_state;
        
        // Default outputs
        valid_out <= 1'b0;
        
        // Data processing
        if (valid_in) begin
            case (state)
                IDLE: begin
                    first_byte <= data_in;
                end
                HAS_FIRST_BYTE: begin
                    data_out <= {first_byte, data_in};
                    valid_out <= 1'b1;
                end
            endcase
        end
    end
end

endmodule