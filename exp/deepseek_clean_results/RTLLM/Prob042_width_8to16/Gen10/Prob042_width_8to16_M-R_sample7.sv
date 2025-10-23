module width_8to16 (
    input wire clk,
    input wire rst_n,
    input wire valid_in,
    input wire [7:0] data_in,
    
    output wire valid_out,
    output wire [15:0] data_out
);

// State definitions
localparam IDLE = 1'b0;
localparam GOT_FIRST_BYTE = 1'b1;

reg state, next_state;
reg [7:0] stored_byte;
reg [15:0] output_reg;
reg valid_reg;

// State transition logic
always @(*) begin
    case (state)
        IDLE: next_state = (valid_in) ? GOT_FIRST_BYTE : IDLE;
        GOT_FIRST_BYTE: next_state = (valid_in) ? IDLE : GOT_FIRST_BYTE;
        default: next_state = IDLE;
    endcase
end

// State storage and output generation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
        stored_byte <= 8'b0;
        output_reg <= 16'b0;
        valid_reg <= 1'b0;
    end else begin
        state <= next_state;
        valid_reg <= 1'b0;  // Default
        
        if (valid_in) begin
            case (state)
                IDLE: stored_byte <= data_in;
                GOT_FIRST_BYTE: begin
                    output_reg <= {stored_byte, data_in};
                    valid_reg <= 1'b1;
                end
            endcase
        end
    end
end

// Continuous assignments for outputs
assign valid_out = valid_reg;
assign data_out = output_reg;

endmodule